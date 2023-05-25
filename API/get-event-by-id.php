<?php

$event_id = isset($_GET["id"]) ? $_GET["id"] : 0;

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
        'aboutEn' => $row['about_en'],
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
    );

    $place_id = $row['owner_place_id'];
    $user_id = $row['owner_user_id'];
    $event_id = $row['id'];
}

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


if (is_null($place_id)) {
    $event += ['ownerPlace' => null];
} else {

    $sql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.photo, Place.address, Place.latitude, Place.longitude, Place.is_active, Place.is_checked FROM Place INNER JOIN PlaceType ON PlaceType.id = Place.type_id WHERE Place.id = $place_id";

    $place = array();
    if ($place_result = mysqli_query($conn, $sql)) {
        while ($row = $place_result->fetch_assoc()) {
            $place = array(
                'id' => $row['id'],
                'name' => $row["name"],
                'type' => $row['type'],
                'photo' => $row['photo'],
                'address' => $row['address'],
                'latitude' => $row['latitude'],
                'longitude' => $row['longitude'],
                'isActive' => $row['is_active'],
                'isChecked' => $row['is_checked'],
            );
            $event += ['place' => $place];
        }
    } else {
        $conn->close();
        $json = array('error' => 4464, 'errorDescription' => 'mysqli_query city_result error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
}

if (is_null($user_id)) {
    $event += ['ownerUser' => null];
} else {

    $sql = "SELECT id, name, photo FROM User WHERE id = $user_id";

    if ($user_result = mysqli_query($conn, $sql)) {
        while ($row = $user_result->fetch_assoc()) {
            $user = array(
                'id' => $row['id'],
                'name' => $row["name"],
                'photo' => $row['photo'],
            );
            $event += ['ownerUser' => $user];
        }
    } else {
        $conn->close();
        $json = array('error' => 4464, 'errorDescription' => 'mysqli_query city_result error');
        echo json_encode($json, JSON_NUMERIC_CHECK);
        exit;
    }
}



$conn->close();
$json = array('event' => $event);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
