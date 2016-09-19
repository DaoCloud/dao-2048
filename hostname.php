<?php
header('Access-Control-Allow-Origin: *');
if ("/" == $_SERVER["REQUEST_URI"]) {
    echo gethostname();
}
?>
