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
		$designation = $_POST["designation"];
		$sql = "UPDATE produto SET design = '$designation' WHERE ean = $ean;";
		$db->query($sql);		
		$db->query("commit;");

		$check = "SELECT * FROM produto WHERE ean = $ean;";
		$result = $db->query($check);

		echo("<table border=\"1\">\n");
		echo("<tr><td>Product EAN</td><td>Designacao</td><td>Categoria</td></tr>\n");
		foreach($result as $row)
		{
			echo("<tr><td>");
			echo($row['ean']);
			echo("</td><td>");
			echo($row['design']);
			echo("</td><td>");
			echo($row['categoria']);
			echo("</td></tr>\n");
		}
		echo("</table>\n");

		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>