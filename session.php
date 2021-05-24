 <?php

    session_start();
    ini_set("display_errors","1");
    error_reporting(E_ALL);
    header('Access-Control-Allow-Origin: *');
    $type ="";
    $session ="";
    $matricola = "";
    $return = array();

    if(isset($_SESSION["login_studente"])){
        $session = $_SESSION["login_studente"];
        $matricola = $_SESSION["matricola"];
        $type ="studente";
        $return = array("result"=>$session,"type"=>$type, "matricola"=>$matricola);
    }
    if(isset($_SESSION["login_docente"])){
        $session = $_SESSION["login_docente"];
        $type ="docente";
        $return = array("result"=>$session, "type"=>$type);
    }
    if(isset($_SESSION["login_personale"])){
        $session = $_SESSION["login_personale"];
        $type ="personale";
        $return = array("result"=>$session, "type"=>$type);
    }
   
    echo json_encode($return);
?> 