<?php
    session_start();
    ini_set("display_errors","1");
    error_reporting(E_ALL);
    header('Access-Control-Allow-Origin: *');
    include 'connect.php';

    $connessione = database_connect();

    $query = "";
    $command = "";
    $return = array();
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $entityBody = file_get_contents('php://input');
        $arrayBody = json_decode($entityBody,TRUE);
        //echo var_dump($arrayBody)."<br>";//
        $query = $arrayBody["query"];
        $command = $arrayBody["command"];
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $query = $_GET["query"];
        $command = $_GET["command"];
    }
    //echo $query."<br>";//
    if($query!=""){

        $res_query = mysqli_query($connessione, $query);
        //echo "res query".$res_query."<br>";//
        //echo gettype($res_query)."<br>";//
        //echo var_dump($res_query instanceof mysqli_result)."<br>";  //
        
        if($res_query instanceof mysqli_result){
            $count = mysqli_num_rows($res_query);
            if($count>0){
                $results = array();
                while($row = mysqli_fetch_assoc($res_query)){
                    $results[] = $row;
                }
                $return = $results;
                $return += array("result"=>"multiple rows");
            }else{
                $return = array("result"=>"zero rows");
            }
        }
        else{
            if($res_query==""){
                $return = array("result"=>"succes");
            }else{
                $return= array("result"=>"unsucces");
            }
        }
    }else{
        $return= array("result"=>"empty query");
    }
    //EXECUTION OF COMMANDS
    switch ($command) {
        case "SET_SESSION":
            if($return["result"]=="multiple rows"){
                $_SESSION["login_studente"] = $results[0]["email"];
                $_SESSION["matricola"] = $results[0]["Matricola"];
                if(isset($_SESSION["login_studente"])){
                    $return += array("session_setted"=>"true");
                }
            }
            break;
        default:
            break;
    }
    echo json_encode($return);
?>