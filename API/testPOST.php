<?php

$handle = fopen("php://input", "rb");
$raw_post_data = '';
while (!feof($handle)) {
    $raw_post_data .= fread($handle, 8192);
}
fclose($handle);

$request_data = json_decode($raw_post_data, true);

header("Content-Type: application/json");


$email = trim($request_data["email"]);
$password = trim($request_data["password"]);

$json = array('email' => $email, 'password' => $password);
echo json_encode($json);
