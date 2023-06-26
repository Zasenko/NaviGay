<?php

$ids = isset($_GET['ids']) ? explode(',', $_GET['ids']) : [];

require_once('dbconfig.php');

$places = array();

foreach ($ids as $id) {
    if (is_numeric($id)) {
        $sql = "SELECT Place.id, Place.name, PlaceType.name as type, Place.photo, Place.address, Place.latitude, Place.longitude, Place.is_active, Place.is_checked FROM Place INNER JOIN PlaceType ON PlaceType.id = Place.type_id WHERE Place.id = ?";
        $stmt = $conn->stmt_init();
        if (!$stmt->prepare($sql)) {
            $conn->close();
            $json = array('error' => 3, 'errorDescription' => '177 Prepare Error');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }
        $stmt->bind_param('i', $id);
        if (!$stmt->execute()) {
            $conn->close();
            $json = array('error' => 4, 'errorDescription' => '1 Execute error');
            echo json_encode($json, JSON_NUMERIC_CHECK);
            exit;
        }
        $places_result = $stmt->get_result();
        $stmt->close();
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
}
$conn->close();
$json = array('places' => $places);
echo json_encode($json, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
exit;
