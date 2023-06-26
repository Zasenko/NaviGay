<?php

$user_email = isset($_POST["email"]) ? $_POST["email"] : '';
$user_password = isset($_POST["password"]) ? $_POST["password"] : '';
$user_email = isset($_POST["email"]) ? filter_var($_POST["email"], FILTER_SANITIZE_EMAIL) : '';
$user_email = filter_var($user_email, FILTER_SANITIZE_EMAIL);

if (!filter_var($user_email, FILTER_VALIDATE_EMAIL)) {
    $json = array('error' => 10, 'errorDescription' => 'Valid email');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$user_name = strstr($user_email, '@', true);
if (strlen($user_password) < 8) {
    $json = array('error' => 11, 'errorDescription' => 'Password must be at least 8 characters');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
if (!preg_match("/[a-z]/i", $user_password)) {
    $json = array('error' => 12, 'errorDescription' => 'Password must contain at least one letter');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
if (!preg_match("/[0-9]/", $user_password)) {
    $json = array('error' => 13, 'errorDescription' => 'Password must contain at least one nummber');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

require_once("dbconfig.php");
$sql = "SELECT * FROM User WHERE email = ? LIMIT 1";
$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '7 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param("s", $user_email);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$result = $stmt->get_result();
if (!($result->num_rows > 0)) {
    $conn->close();
    $json = array('error' => 14, 'errorDescription' => 'No user.');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
while ($row = $result->fetch_assoc()) {

    if (password_verify($user_password, $row['password'])) {
        $user = array(
            'id' => $row['id'],
            'name' => $row["name"],
            'bio' => $row["bio"],
            'photo' => $row['photo'],
            'instagram' => $row['instagram'],
            'status' => $row['status'],
            'lastUpdate' => $row['updated_at']
        );
        $user_id = $row['id'];

        $sql = "SELECT place_id FROM User_LikedPlace WHERE user_id = $user_id";

        $liked_places = array();
        if ($liked_places_result = mysqli_query($conn, $sql)) {
            while ($row = $liked_places_result->fetch_assoc()) {
                $liked_place_id = $row['place_id'];
                array_push($liked_places, $liked_place_id);
            }
        } else {
            $conn->close();
            $json = array('error' => 44, 'errorDescription' => 'mysqli_query city_result error');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }
        $user += ['likedPlacesId' => $liked_places];
    } else {
        $conn->close();
        $json = array('error' => 100, 'errorDescription' => 'Wrong password');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
}
$conn->close();
$json = array('user' => $user);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
