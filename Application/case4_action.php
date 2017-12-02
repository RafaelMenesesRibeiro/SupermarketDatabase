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
		
		$sql = "SELECT * FROM produto WHERE ean = $ean;";
		$result = $db->query($sql);
		//Checks if the product exists.
		$productExists = false;
		$oldDesign = '';
		foreach ($result as $prod) {
			$oldDesign = $prod['design'];
			$productExists = true;
		}
		//If it doens't exist, prints an error message.
		if (!$productExists) {
			echo("<p>The product does not exist. Use <a href='http://web.ist.utl.pt/ist426058/case2.php'>this page</a> to add it.</p>");
		}
		//If it exists, updates the designation.
		else {
			$sql = "UPDATE produto SET design = '$designation' WHERE ean = $ean;";
			$db->query($sql);
			echo("<p>The designation of your product was changed from
				$oldDesign to $designation</p>");
		}

		$db->query("commit;");
		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>