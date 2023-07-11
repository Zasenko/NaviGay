<?php

// Проверка существования параметров GET
if (!isset($_GET['user_latitude']) || !isset($_GET['user_longitude'])) {
    $json = array('error' => 400, 'errorDescription' => 'Missing latitude or longitude parameter');
    echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    exit;
}

// Получение и проверка параметров GET
$userLatitude = floatval($_GET['user_latitude']);
$userLongitude = floatval($_GET['user_longitude']);

// Проверка валидности параметров
if (!is_numeric($userLatitude) || !is_numeric($userLongitude)) {
    $json = array('error' => 400, 'errorDescription' => 'Invalid latitude or longitude value');
    echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    exit;
}

require_once('dbconfig.php');

$places = array();
$events = array();

// Подготовка SQL запроса для получения мест
$placeSql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.photo, Place.address, Place.latitude, Place.longitude, Place.is_active, Place.is_checked
             FROM Place
             INNER JOIN PlaceType ON PlaceType.id = Place.type_id
             WHERE SQRT(POW(latitude - $userLatitude, 2) + POW(longitude - $userLongitude, 2)) <= 10
             AND Place.is_active = 1";

// Выполнение запроса для получения мест
$placeResult = $conn->query($placeSql);

// Обработка результатов запроса для мест
if ($placeResult) {
    while ($placeRow = $placeResult->fetch_assoc()) {
        $id = $placeRow['id'];

        // Подготовка SQL запроса для получения тегов места
        $tagsSql = "SELECT Tag.name as name FROM PlaceTag INNER JOIN Tag ON Tag.id = PlaceTag.tag_id WHERE PlaceTag.place_id = $id";
        $tagsResult = $conn->query($tagsSql);

        $tags = array();
        if ($tagsResult) {
            while ($tagRow = $tagsResult->fetch_assoc()) {
                $tags[] = $tagRow['name'];
            }
        } else {
            $json = array('error' => 500, 'errorDescription' => 'Failed to fetch place tags');
            echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
            exit;
        }

        $placeRow['tags'] = $tags;
        $places[] = $placeRow;
    }
} else {
    $json = array('error' => 500, 'errorDescription' => 'Failed to fetch places');
    echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    exit;
}

// Подготовка SQL запроса для получения событий
$eventSql = "SELECT Event.id, Event.name, EventType.name as type, Event.cover, Event.address, Event.latitude, Event.longitude, Event.start_time, Event.close_time, Event.is_active, Event.is_checked
             FROM Event
             INNER JOIN EventType ON EventType.id = Event.type_id
             WHERE SQRT(POW(latitude - $userLatitude, 2) + POW(longitude - $userLongitude, 2)) <= 10
             AND Event.close_time >= NOW()
             AND Event.is_active = 1";

// Выполнение запроса для получения событий
$eventResult = $conn->query($eventSql);

// Обработка результатов запроса для событий
if ($eventResult) {
    while ($eventRow = $eventResult->fetch_assoc()) {
        $eventId = $eventRow['id'];

        // Подготовка SQL запроса для получения тегов события
        $eventTagsSql = "SELECT Tag.name as name FROM EventTag INNER JOIN Tag ON Tag.id = EventTag.tag_id WHERE EventTag.event_id = $eventId";
        $eventTagsResult = $conn->query($eventTagsSql);

        $eventTags = array();
        if ($eventTagsResult) {
            while ($eventTagRow = $eventTagsResult->fetch_assoc()) {
                $eventTags[] = $eventTagRow['name'];
            }
        } else {
            $json = array('error' => 500, 'errorDescription' => 'Failed to fetch event tags');
            echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
            exit;
        }

        $eventRow['tags'] = $eventTags;
        $events[] = $eventRow;
    }
} else {
    $json = array('error' => 500, 'errorDescription' => 'Failed to fetch events');
    echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    exit;
}

$conn->close();

$json = array('places' => $places, 'events' => $events);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
