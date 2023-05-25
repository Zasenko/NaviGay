<?php

require_once('languages.php');

$event_id = isset($_GET["id"]) ? $_GET["id"] : 0;
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

require_once('dbconfig.php');

$sql = "SELECT Event.id, Event.name, EventType.name as type, Event.about_en, Event.about as about, Event.lang, Event.cover, Event.address, Event.latitude, Event.longitude, Event.start_time, Event.close_time, Event.country_id , Event.region_id , Event.city_id,  Event.www,  Event.fb,  Event.insta,  Event.tickets, Event.fee, Event.fee_about, Сurrency.name as currency, Event.placeName, Event.owner_place_id, Event.owner_user_id, Event.is_active, Event.is_checked FROM Event INNER JOIN EventType ON EventType.id = Event.type_id INNER JOIN Сurrency ON Сurrency.id = Event.currency_id WHERE Event.id = ? LIMIT 1";

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 36, 'errorDescription' => '166667 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $event_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$events_result = $stmt->get_result();
$stmt->close();

$event = array();
while ($row = $events_result->fetch_assoc()) {
    $event = array(
        'id' => $row['id'],
        'name' => $row["name"],
        'type' => $row['type'],
        'cover' => $row['cover'],
        'address' => $row['address'],
        'latitude' => $row['latitude'],
        'longitude' => $row['longitude'],
        'startTime' => $row['start_time'],
        'finishTime' => $row['close_time'],
        'isActive' => $row['is_active'],
        'isChecked' => $row['is_checked'],
        'aboutEn' => $row['aboutEn'],
        'about' => $row['about'],
        'lang' => $row['lang'],
        'countryId' => $row['country_id'],
        'cityId' => $row['city_id'],
        'id' => $row['id'],
        'www' => $row['www'],
        'fb' => $row['fb'],
        'insta' => $row['insta'],
        'tickets' => $row['tickets'],
        'fee' => $row['fee'],
        'feeAbout' => $row['fee_about'],
        'currency' => $row['currency'],
        'placeName' => $row['placeName'],
        'owner_place_id' => $row['owner_place_id'],
        'owner_user_id' => $row['owner_place_id'],
    );

    $event_id = $row['id'];

    $sql = "SELECT Tag.name as name FROM EventTag INNER JOIN Tag ON Tag.id = EventTag.tag_id WHERE EventTag.event_id = $event_id";
    $tags = array();
    if ($tags_result = mysqli_query($conn, $sql)) {
        while ($row = $tags_result->fetch_assoc()) {
            array_push($tags, $row['name']);
        }
    } else {
        $conn->close();
        $json = array('error' => 44, 'errorDescription' => 'mysqli_query city_result error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
    $event += ['tags' => $tags];
}



$conn->close();
$json = array('event' => $event);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
