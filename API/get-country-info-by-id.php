<?php

require_once('languages.php');

$country_id = isset($_GET["id"]);
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

require_once('dbconfig.php');

$sql = "SELECT id, name_$lang as name, about_$lang as about, flag_emoji as flag, photo, is_active as isActive, TIMESTAMP(updated_at) AS lastUpdate FROM Country WHERE id = ? LIMIT 1";
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
$result = $stmt->get_result();
while ($row = $result->fetch_object()) {
    $country = $row;
}
$stmt->close();

$sql = "SELECT City.id as id, City.name_$lang as name, City.is_active as isActive, Region.id as regionId, Region.name_$lang as regionName FROM City INNER JOIN Region ON Region.id = region_id WHERE City.country_id = ?";
$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '18 Prepare Error');
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
$result = $stmt->get_result();

$cities = array();

while ($row = $result->fetch_object()) {
    $city = $row;
    array_push($cities, $city);
}
$country->cities = $cities;

$stmt->close();
$conn->close();
$json = array('country' => $country);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
