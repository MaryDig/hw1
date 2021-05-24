<?php 
    session_start();
?>
<!DOCTYPE html>
<html>
    <head>  
        <link rel="stylesheet" href="mhw1.css">
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        <meta charset="UTF-8">
    </head>
    <body>
        <?php //aggiungere info sul login effettuato
            echo isset($_SESSION['login_studente']);
        ?>
        <nav>
            <div id="logo">
                <img src="logo.png">
            </div>
            <div id="bottoni">
                <a href="home.php" >Home</a>
                <?php //aggiungere info sul login effettuato
                    if(isset($_SESSION['login_studente'])){
                ?>
                    <a href="areaStudente.html" >Area Studenti</a>

                <?php 
                    }else if(isset($_SESSION['login_docente'])){
                ?>
                        <a href="areaDocente.html" >Area Studenti</a>
                <?php
                    }else if(isset($_SESSION['login_docente'])){
                ?>
                        <a href="areaDocente.html" >Area Studenti</a>
                <?php
                    }else{
                ?>
                        <a href="loginStudente.html" >Accesso Studenti</a>
                        <a href="loginDocente.html" >Accesso Docenti</a>
                        <a href="loginAmministratore.html" >Accesso Pesonale</a>
                <?php
                    }
                ?>
                <a href="">Contatti</a>
                <a href="home.php" class="hidden" id="logoutLink">Log Out</a>
            </div>

        </nav>
        <header>
            <div id="overlay">
                <h1>Istituto Musicale Vincenzo Bellini</h1>
                    <div id="bottoni">
                        <a class="bottone2">Scopri di più</a>
                    </div>
            </div>

        </header>
        <section>  
            <div id="flex-container">
                <div class="item">
                    <div class="style-item1">
                        <a class="bottone2">Concorsi</a>
                    </div>
                </div>
                <div class="item">
                    <div class="style-item2">
                        <a class="bottone2">Avvisi</a>
                    </div>
                </div>
                <div class="item">
                    <div class="style-item3">
                        <a class="bottone2">Erasmus</a>
                    </div>
                </div>
            </div>
        </section>
        <section>
            <div id="flex-container">
                <div class="item2">
                    <div class="style-item4">
                        <a class="bottone2">Offerta Formativa</a>
                    </div>
                </div>
                <div class="item2">
                    <div class="style-item5">
                        <a class="bottone2">Seminari</a>
                    </div>
                </div>
                <div class="item2">
                    <div class="style-item6">
                        <a class="bottone2">Concerti del bellini</a>
                    </div>
                </div>
            </div>     
        </section>
        <footer>Mary Di Gregorio matricola O46001623</footer>
        <script src="nav.js"></script>
    </body>
</html>
