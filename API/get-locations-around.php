<?php

require_once('languages.php');

$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

$latitude = $_GET["latitude"];
$longitude = $_GET["longitude"];


$json = array('latitude' => $latitude, 'longitude' => $longitude, 'lang' => $lang);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;

require_once('dbconfig.php');

$sql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.photo, Place.address, Place.latitude, Place.longitude, Place.is_active, Place.is_checked, (6371 * acos(cos(radians($latitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($longitude)) + sin(radians($latitude)) * sin(radians(latitude)))) AS distance FROM Place INNER JOIN PlaceType ON PlaceType.id = Place.type_id HAVING distance <= 10 ORDER BY distance";


if ($result = $conn->query($sql)) {
    $places = array();
    while ($row = $places_result->fetch_assoc()) {
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
            'distance' => $row['distance'],
        );
        $sql = "SELECT Tag.name as name FROM PlaceTag INNER JOIN Tag ON Tag.id = PlaceTag.tag_id WHERE PlaceTag.place_id = $id";
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
        $place += ['tags' => $tags];
        array_push($places, $place);
    }
}

$sql = "SELECT Event.id, Event.name, EventType.name as type, Event.cover, Event.address, Event.latitude, Event.longitude, Event.start_time, Event.close_time, Event.is_active, Event.is_checked, (6371 * acos(cos(radians($latitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($longitude)) + sin(radians($latitude)) * sin(radians(latitude)))) AS distance FROM Event INNER JOIN EventType ON EventType.id = Event.type_id WHERE DATE(Event.close_time) >= now() HAVING distance <= 10";

if ($result = $conn->query($sql)) {
    $events = array();
    while ($row = $result->fetch_assoc()) {
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
            'distance' => $row['distance'],
        );
        array_push($events, $event);
    }
}

$json = array('places' => $places, 'events' => $events);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);

$conn->close();
