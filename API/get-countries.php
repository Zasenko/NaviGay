<?php

require_once('languages.php');

$country_id = isset($_GET['id']);
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

$sql = "SELECT id, name_$lang, about_$lang, flag_emoji, photo, is_active, TIMESTAMP(updated_at) AS updated_at FROM Country WHERE id = ? LIMIT 1";

require_once('dbconfig.php');

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '7 Prepare Error');
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

while ($row = $result->fetch_assoc()) {
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
$conn->close();
$json = array('country' => $country);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
