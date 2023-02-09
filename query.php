<?php

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $host = $_POST['host'];
    $username = $_POST['username'];
    $password = $_POST['password'];
    $query = $_POST['query'];
    $dbname = $_POST['dbname'];
    
    // Connect to host server
    $conn = mysqli_connect($host, $username, $password, $dbname);
    
    if (!$conn) {
        // If connection fails, return an error message
        $response = array("error" => "Unable to connect to host server");
        echo json_encode($response);
        exit;
    }
    
    // Execute the query
    $result = mysqli_query($conn, $query);
    
    if (!$result) {
        // If query fails, return an error message
        $response = array("error" => "Unable to execute the query");
        echo json_encode($response);
        exit;
    }
    
    // If query succeeds, return the result as a JSON object
    $response = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $response[] = $row;
    }
    echo json_encode($response);
    exit;
}

?>
