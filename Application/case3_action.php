<?php
	try {
		$host = "db.ist.utl.pt";
		$user ="ist426058";
		$password = "vjwj7059";
		$dbname = $user;
		$db = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
		$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$db->query("start transaction;");
		$ean = $_POST["ean"];
		$sql = "
			SELECT Rep.ean, Rep.operador, Rep.instante, Rep.unidades
			FROM reposicao as Rep
			WHERE Rep.ean = $ean;
			";
		$result = $db->query($sql);
		
		//Checks if there was any restocking event.
		$hasEvents = false;
		$events = array();
		foreach($result as $row) {
			$event = array();
			array_push($event, $row['operador'], $row['instante'], $row['unidades']);
			array_push($events, $event);
			$hasEvents = true;
			
		}
		//If there wasn't any, prints an error message.
		if (!$hasEvents) {
			echo("<p>The given product hasn't been restocked yet.</p>");
		}
		//If there was, shows them in a table.
		else {
			echo("Restocking events for product $ean");
			echo("<table border=\"1\">\n");
			echo("<tr><td>Operator</td><td>Instante</td><td>Unidades</td></tr>\n");
			for ($x = 0; $x < count($events); $x++) {
				echo("<tr><td>");
				echo($events[$x][0]);
				echo("</td><td>");
				echo($events[$x][1]);
				echo("</td><td>");
				echo($events[$x][2]);
				echo("</td></tr>\n");
			}
			echo("</table>\n");
		}

		$db->query("commit;");
		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>