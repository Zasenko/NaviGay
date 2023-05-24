<?php

require_once('languages.php');

$place_id = isset($_GET["id"]) ? $_GET["id"] : 0;
$lang = isset($_GET['lang']) && in_array($_GET['lang'], $languages) ? $_GET['lang'] : 'en';

require_once('dbconfig.php');

$sql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.about_$lang as about, Place.photo, Place.address, Place.latitude, Place.longitude, Place.country_id , Place.region_id , Place.city_id,  Place.www,  Place.fb,  Place.insta,  Place.phone, Place.is_active, Place.is_checked FROM Place INNER JOIN PlaceType ON PlaceType.id = Place.type_id WHERE Place.id = ? LIMIT 1";

$stmt = $conn->stmt_init();
if (!$stmt->prepare($sql)) {
    $conn->close();
    $json = array('error' => 3, 'errorDescription' => '167 Prepare Error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$stmt->bind_param('i', $place_id);
if (!$stmt->execute()) {
    $conn->close();
    $json = array('error' => 4, 'errorDescription' => '1 Execute error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}

$place_result = $stmt->get_result();
$stmt->close();

$place = array();
while ($row = $place_result->fetch_assoc()) {
    $place = array(
        'id' => $row['id'],
        'name' => $row["name"],
        'type' => $row['type'],
        'about' => $row["about"],
        'photo' => $row['photo'],
        'address' => $row['address'],
        'latitude' => $row['latitude'],
        'longitude' => $row['longitude'],
        'countryId' => $row['country_id'],
        'regionId' => $row["region_id"],
        'cityId' => $row["city_id"],
        'www' => $row['www'],
        'fb' => $row['fb'],
        'insta' => $row['insta'],
        'name' => $row["name"],
        'phone' => $row["phone"],
        'isActive' => $row['is_active'],
        'isChecked' => $row['is_checked'],
    );
    $place_id = $row['id'];
}

$sql = "SELECT day_of_week, opening_time, closing_time FROM PlaceWorkingTime WHERE place_id = $place_id";

$working_times = array();
if ($working_times_result = mysqli_query($conn, $sql)) {
    while ($row = $working_times_result->fetch_assoc()) {
        $working_time = array(
            'day_of_week' => $row['day_of_week'],
            'opening_time' => $row["opening_time"],
            'closing_time' => $row["closing_time"],
        );
        array_push($working_times, $working_time);
    }
} else {
    $conn->close();
    $json = array('error' => 44, 'errorDescription' => 'mysqli_query city_result error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$place += ['workingTimes' => $working_times];


$sql = "SELECT photo FROM PlacePhoto WHERE place_id = $place_id";
$photos = array();
if ($photos_result = mysqli_query($conn, $sql)) {
    while ($row = $photos_result->fetch_assoc()) {
        array_push($photos, $row["photo"]);
    }
} else {
    $conn->close();
    $json = array('error' => 44, 'errorDescription' => 'mysqli_query city_result error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$place += ['photos' => $photos];

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

$sql = "SELECT PlaceComment.id, User.id as userId, User.name as userName, User.photo as userPhoto, PlaceComment.comment, PlaceComment.created_at FROM PlaceComment INNER JOIN User ON PlaceComment.user_id = User.id WHERE place_id = $place_id";

$commnets = array();
if ($commnets_result = mysqli_query($conn, $sql)) {
    while ($row = $commnets_result->fetch_assoc()) {
        $commnet = array(
            'id' => $row['id'],
            'userId' => $row["userId"],
            'userName' => $row["userName"],
            'userPhoto' => $row["userPhoto"],
            'comment' => $row["comment"],
            'createdAt' => $row["created_at"],
        );
        array_push($commnets, $commnet);
    }
} else {
    $conn->close();
    $json = array('error' => 4444444555555, 'errorDescription' => 'mysqli_query city_result error');
    echo json_encode($json, JSON_NUMERIC_CHECK);
    exit;
}
$place += ['comments' => $commnets];

$conn->close();
$json = array('place' => $place);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
