<?php
	function supplierExists($db, $nif) {
		$sql = "SELECT * FROM fornecedor WHERE nif = $nif;";
		$result = $db->query($sql);
		foreach ($result as $forn) {
			$h = $forn['nif'];
			return true;
		}
		return false;
	}

	try {
		$host = "db.ist.utl.pt";
		$user ="ist426058";
		$password = "vjwj7059";
		$dbname = $user;
		$db = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
		$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$db->query("start transaction;");
		
		$case = $_POST["case"];
	
		switch($case) {
			case 1:
				$ean = $_POST["ean"];
				$design = $_POST["designation"];
				$category = $_POST["category"];
				$nif = $_POST["nif"];
				$date = $_POST["date"];

				//Checks if the category exists.
				$sql = "SELECT * FROM categoria WHERE nome = '$category';";
				$result = $db->query($sql);
				$categoryExists = false;
				foreach ($result as $cat) {
					$name = $cat['nome'];
					$categoryExists = true;
				}
				//If the category isn't in the database yet prints an error
				//message.
				if (!$categoryExists) {
					echo("<p>The category provided does not exist in the database.
						Use <a href='http://web.ist.utl.pt/ist426058/case1.php'>
						this page</a> to add one and then create the product.</p>");
					break;
				}

				//Checks if the supplier exists.
				//If the supplier isn't in the database yet prints an error
				//message.
				if (!supplierExists($db, $nif)) {
					echo("<p>The supplier provided does not exist in the database.
						Use the previous page to add one and then create the product.</p>");
					break;
				}

				$secondarySuppliers = array();
				$i = 0;
				while (true) {
					$i += 1;
					$variableName = 'secondary' . $i;
					if (!isset($_POST[$variableName])) {
						break;
					}
					$newSec = $_POST[$variableName];

					//Checks if the supplier exists.
					if (!supplierExists($db, $newSec)) {
						echo("<p>The supplier provided does not exist in the database.
							Use the previous page to add one and then create the product.</p>");
						break;
					}
					array_push($secondarySuppliers, $newSec);
				}

				//If the supplier was already in the database, creates the product.
				$sql = "INSERT INTO produto VALUES ($ean, '$design', '$category', '$nif', '$date');";
				$db->query($sql);

				for ($x = 0; $x < count($secondarySuppliers); $x++) {
					$nif_sec = $secondarySuppliers[$x];
					$sql = "INSERT INTO fornece_sec VALUES ($nif_sec, $ean);";
					$db->query($sql);
				}

				break;

			case 2:
				$ean = $_POST["ean"];

				//Checks if the product existed.
				$sql = "SELECT * FROM produto WHERE ean = $ean;";
				$result = $db->query($sql);
				$productExists = false;
				foreach ($result as $prod) {
					$ean = $prod['ean'];
					$productExists = true;
				}
				//If it doens't, prints an error message.
				if (!$productExists) {
					echo("<p>The product provided does not exist in the database.");
					break;
				}

				//If it exists, deletes the relations in "fornece_sec".
				$sql = "DELETE FROM fornece_sec WHERE ean = $ean;";
				$db->query($sql);
				//And also deletes the relation in "produto".
				$sql = "DELETE FROM produto WHERE ean = $ean;";
				$db->query($sql);

				break;

			case 3:
				$nif = $_POST["nif"];
				$nome = $_POST["nome"];


				//Checks if the to-be-added supplier's nif already existed.
				//If it does, prints an error message.
				if (supplierExists($db, $nif)) {
					echo("<p>The NIF provided already exists in the database.");
					break;
				}
				//If it didn't, adds it.
				$sql = "INSERT INTO fornecedor VALUES ($nif, '$nome');";
				$db->query($sql);

				break;

			case 4:
				$nif = $_POST["nif"];

				//Checks if the to-be-deleted supplier's nif existed.
				//If it doesn't, prints an error message.
				if (!supplierExists($db, $nif)) {
					echo("<p>The NIF provided doesn't exist in the database.");
					break;
				}

				//If it does, checks if the to-be-deleted is a primary supplier.
				$sql = "SELECT * FROM produto WHERE forn_primario = $nif;";
				$result = $db->query($sql);
				$isPrimary = false;
				$eans = array();
				$designs = array();
				foreach ($result as $prod) {
					$ean = $prod['ean'];
					$design = $prod['design'];
					array_push($eans, $ean);
					array_push($designs, $design);
					$isPrimary = true;
				}
				//If it is, prints an error.
				if ($isPrimary) {
					echo("<p>The supplier provided is a primary supplier.
						This means it cannot be deleted unitl all the products
						listed below are changed in the database so that
						their respective primary supplier is another.</p>");
					
					echo("<table border=\"1\">\n");
					echo("<tr><td>EAN</td><td>Designacao</td></tr>");
					for ($x = 0; $x < count($eans); $x++) {
						$prodEAN = $eans[$x];
						$prodDesign = $designs[$x];
						echo("<tr><td>$prodEAN</td><td>$prodDesign</td></tr>");
					}
					echo("</table>");
					break;
				}

				//If its not deletes the relations in "fornece_sec".
				$sql = "DELETE FROM fornece_sec WHERE nif = $nif";
				$db->query($sql);

				//Finaly, deletes the supplier from the relation "fornecedor".
				$sql = "DELETE FROM fornecedor WHERE nif = $nif";
				$db->query($sql);

				break;
		}
		
		$db->query("commit;");
		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>