<?php
function getPost()
{
    if (!empty($_POST)) {
        return $_POST;
    }
    $post = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() == JSON_ERROR_NONE) {
        return $post;
    }
    return [];
}
