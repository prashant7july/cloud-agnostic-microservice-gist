<?php
try{
    # this is a pretty standard MySQL connection script using pdo_mysql
    # http://php.net/manual/en/pdo.construct.php

    # we use environment variables for our MySQL connection
    # the env variables are MYSQL_HOST, MYSQL_USER, and MYSQL_PASSWORD
    # in our example MYSQL_HOST is mysql.default.svc.cluster.local
    # The domain managed by this Service takes the form: $(service name).$(namespace).svc.cluster.local (where “cluster.local” is the cluster domain)
    # MYSQL_USER is varMyDBUser and MYSQL_PASSWORD is varMyDBPass
    # these env variables are set for our PHP server by Kubernetes when we create the php.yaml file
    # the sensitive data itself is set in a Kubernetes Secret when we create the secrets.yaml file

    $mysql_host = getenv('RATING_MYSQL_HOST') ? getenv('RATING_MYSQL_HOST') : 'rating-mysql' ;
    $dbh = new pdo( "mysql:host=$mysql_host:3306;dbname=ratings",
                    getenv('RATING_MYSQL_USER'),
                    getenv('RATING_MYSQL_PASSWORD'),
                    array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
                    
    //$dbh = new pdo( "mysql:host=rating-mysql:3306;dbname=ratings;charset=utf8mb4",'root',"varMyRootPass",array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
    $dsn = getenv('RATING_PDO_URL') ? getenv('RATING_PDO_URL') : 'mysql:host=rating-mysql;dbname=ratings;charset=utf8mb4';
    $result = $dbh->query("show tables");
    while ($row = $result->fetch(PDO::FETCH_NUM)) {
        echo($row[0]) . "<br />";
    }
    die(json_encode(array('outcome' => true)));
}
catch(PDOException $ex){
    die(json_encode(array('outcome' => false, 'message' => "Unable to connect: $ex")));
}
?>