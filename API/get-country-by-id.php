<?php

require_once('languages.php');

$country_id = isset($_GET["id"]) ? $_GET["id"] : 0;
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

require_once('dbconfig.php');

$sql = "SELECT id, name_$lang, about_$lang, flag_emoji, photo, is_active, TIMESTAMP(updated_at) AS updated_at FROM Country  WHERE id = ? LIMIT 1";

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '17 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $country_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$country_result = $stmt->get_result();
$stmt->close();

$country = array();
while ($row = $country_result->fetch_assoc()) {
    $country = array(
        'id' => $row['id'],
        'name' => $row["name_$lang"],
        'about' => $row["about_$lang"],
        'flag' => $row['flag_emoji'],
        'photo' => $row['photo'],
        'cities' => [],
        'isActive' => $row['is_active'],
        'lastUpdate' => $row['updated_at']
    );
}


$sql = "SELECT id, name_$lang as name, is_active as isActive FROM Region WHERE country_id = ?";

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '17 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $country_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$region_result = $stmt->get_result();
$stmt->close();

$regions = array();
while ($row = $region_result->fetch_assoc()) {
    $region = array(
        'id' => $row['id'],
        'name' => $row["name"],
        'isActive' => $row['isActive']
    );

    $region_id = $row['id'];

    $sql = "SELECT id, name_$lang as name, photo, is_active as isActive FROM City WHERE region_id = $region_id";

    $cities = array();
    if ($city_result = mysqli_query($conn, $sql)) {
        while ($row = $city_result->fetch_assoc()) {
            $city = array(
                'id' => $row['id'],
                'name' => $row["name"],
                'photo' => $row["photo"],
                'isActive' => $row['isActive']
            );
            array_push($cities, $city);
        }
    } else {
        $conn->close();
        $json = array('error' => 4, 'errorDescription' => 'mysqli_query city_result error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
    $region += ['cities' => $cities];

    if (count($cities) > 0) {
        array_push($regions, $region);
    }
}
$country += ['regions' => $regions];

$conn->close();
$json = array('country' => $country);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
