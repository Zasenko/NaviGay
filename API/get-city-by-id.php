<?php

require_once('languages.php');

$city_id = isset($_GET["id"]) ? $_GET["id"] : 0;
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

require_once('dbconfig.php');

$sql = "SELECT id, name_$lang as name, about_$lang as about, photo, is_active as isActive FROM City  WHERE id = ? LIMIT 1";

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '167 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $city_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$city_result = $stmt->get_result();
$stmt->close();

$city = array();
while ($row = $city_result->fetch_assoc()) {
    $city = array(
        'id' => $row['id'],
        'name' => $row["name"],
        'about' => $row["about"],
        'photo' => $row['photo'],
        'isActive' => $row['isActive'],
    );
}

$sql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.photo, Place.address, Place.latitude, Place.longitude, Place.is_active, Place.is_checked FROM Place INNER JOIN PlaceType ON PlaceType.id = Place.type_id WHERE Place.city_id = ?";
$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '177 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $city_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$places_result = $stmt->get_result();
$stmt->close();

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
    );

    $place_id = $row['id'];

    // $sql = "SELECT day_of_week, opening_time, closing_time FROM PlaceWorkingTime WHERE place_id = $place_id";

    // $working_times = array();
    // if ($working_times_result = mysqli_query($conn, $sql)) {
    //     while ($row = $working_times_result->fetch_assoc()) {
    //         $working_time = array(
    //             'day_of_week' => $row['day_of_week'],
    //             'opening_time' => $row["opening_time"],
    //             'closing_time' => $row["closing_time"],
    //         );
    //         array_push($working_times, $working_time);
    //     }
    // } else {
    //     $conn->close();
    //     $json = array('error' => 44, 'errorDescription' => 'mysqli_query city_result error');
    //     echo json_encode($json, JSON_NUMERIC_CHECK);
    //     exit;
    // }

    // $place += ['workingTimes' => $working_times];

    $sql = "SELECT Tag.name as name FROM PlaceTag INNER JOIN Tag ON Tag.id = PlaceTag.tag_id WHERE PlaceTag.place_id = $place_id";
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

$city += ['places' => $places];

$conn->close();
$json = array('city' => $city);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
