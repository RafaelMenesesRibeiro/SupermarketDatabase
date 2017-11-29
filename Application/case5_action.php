<?php
	try {
		$host = "db.ist.utl.pt";
		$user ="ist426058";
		$password = "vjwj7059";
		$dbname = $user;
		$db = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
		$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$db->query("start transaction;");
		$category = $_POST["category"];
		$subcategories = array();
		$LIFO = array();
		array_push($LIFO, $category);
		$continue = true;
		while ($continue) {
			if (empty($LIFO)) {
				$continue = false;
			}
			$nextcategory = array_shift($LIFO);
			$sql = "SELECT categoria FROM constituida WHERE super_categoria = '$nextcategory';";
			$result = $db->query($sql);
			foreach ($result as $cat) {
				$catname = $cat['categoria'];
				array_push($LIFO, $catname);
				array_push($subcategories, $catname);
			}
		}		
		$db->query("commit;");

		
		echo("<h3>Sub-categorias</h3>\n");
		echo("<il>");
		for($x = 0; $x < count($subcategories); $x++) {
			$name = $subcategories[$x];
			echo("<li>$name</li>");
		}
		echo("</il>\n");

		$db = null;
	}
	catch (PDOException $e) {
		$db->query("rollback;");
		echo("<p>ERROR: {$e->getMessage()}</p>");
	}
?>