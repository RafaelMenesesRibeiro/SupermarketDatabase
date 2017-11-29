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
		
        echo("<table border=\"1\">\n");
        echo("<tr><td>Product EAN</td><td>Operator</td><td>Instante</td><td>Unidades</td></tr>\n");
        foreach($result as $row)
        {
            echo("<tr><td>");
            echo($row['ean']);
            echo("</td><td>");
            echo($row['operador']);
            echo("</td><td>");
            echo($row['instante']);
            echo("</td><td>");
            echo($row['unidades']);
            echo("</td></tr>\n");
        }
        echo("</table>\n");

		$db->query("commit;");
		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>