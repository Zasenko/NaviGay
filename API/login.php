<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    function getPost()
    {
        if (!empty($_POST)) {
            return $_POST;
        }
        $post = json_decode(file_get_contents('php://input'), true);
        if (json_last_error() == JSON_ERROR_NONE) {
            return $post;
        }
        return [];
    }
    $data = getPost();

    // date_default_timezone_set('Europe/London');
    // $a = date('d.m.Y H:i:s');
    // echo $a;
    // date_default_timezone_set('Australia/Melbourne');
    // $a = date('d.m.Y H:i:s');
    // echo $a;
    // exit;

    $user_email = trim($data["email"]);
    $user_password = trim($data["password"]);

    $user_email = filter_var($user_email, FILTER_SANITIZE_EMAIL);

    if (filter_var($user_email, FILTER_VALIDATE_EMAIL)) {
        $user_name = strstr($user_email, '@', true);
    } else {
        $json = array('error' => 10, 'errorDescription' => 'Valid email');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }

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

    $sql = "SELECT id FROM User WHERE email = ? LIMIT 1";

    $stmt = $conn->stmt_init();
    if (!$stmt->prepare($sql)) {
        $conn->close();
        $json = array('error' => 3, 'errorDescription' => '7 Prepare Error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
    $stmt->bind_param("s", $user_email);
    if ($stmt->execute()) {
        $stmt->store_result();
        if (!($stmt->num_rows() > 0)) {
            $conn->close();
            $json = array('error' => 14, 'errorDescription' => '6 No user.');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }


        $sql = "SELECT * FROM User WHERE email = ? LIMIT 1";
        $stmt = $conn->stmt_init();
        if (!$stmt->prepare($sql)) {
            $conn->close();
            $json = array('error' => 3, 'errorDescription' => '5 Prepare Error');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }
        $stmt->bind_param("s", $user_email);
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $user = array(
                    'id' => $row['id'],
                    'name' => $row["name"],
                    'bio' => $row["bio"],
                    'photo' => $row['photo'],
                    'instagram' => $row['instagram'],
                    'status' => $row['status'],
                    'lastUpdate' => $row['updated_at'],
                );
                $conn->close();
                $json = array('user' => $user);
                echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
                exit;
            }
        } else {
            $conn->close();
            $json = array('error' => 4, 'errorDescription' => '2 Execute error');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }
    } else {
        $conn->close();
        $json = array('error' => 4, 'errorDescription' => '1 Execute error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }

    $conn->close();
}
