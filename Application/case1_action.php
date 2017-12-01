<?php
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
				$categoria = $_POST["categoria"];
				$sql = "INSERT INTO categoria VALUES ('$categoria');";
				$db->query($sql);
				$sql = "INSERT INTO categoria_simples VALUES ('$categoria');";
				$db->query($sql);
				break;

			case 2:
				$category = $_POST["categoria"];
				//Checks if the category has a parent.
				$sql = "SELECT super_categoria FROM constituida WHERE categoria = '$category';";
				$result = $db->query($sql);

				$parent = 'Indefinido';
				$hasparent = false;
				foreach ($result as $cat) {
					$parent = $cat['super_categoria'];
					$hasparent = true;
				}
								
				//Checks if category has children.
				$sql = "SELECT categoria FROM constituida WHERE super_categoria = '$category';";
				$result = $db->query($sql);
				//If the category has children, all of the relations in "constituida" will
				//be changed.
				//Updates all the relations in "constituida" so that all the children
				//that were parented by the to-be-deleted category are now parented
				//by its parent (if it existed) or by a category called "Indefinida"
				//(undefined).
				foreach ($result as $cat) {
					$subcat = $cat['categoria'];
					echo("<p>$subcategory</p>");
					if ($harparent == true) {
						$sql = "UPDATE constituida SET super_categoria = '$parent' WHERE categoria = '$subcat';";	
					}
					else {
						$sql = "DELETE FROM constituida WHERE super_categoria = '$category';";
					}
					$db->query($sql);
				}

				//Updates all products where category was the to-be-deleted one.
				$sql = "UPDATE produto SET categoria = '$parent' WHERE categoria = '$category';";	
				$db->query($sql);

				//Deleted the relation in "constituida" between the to-be-deleted
				//category and its parent.
				$sql = "DELETE FROM constituida WHERE categoria = '$category';";
				$db->query($sql);

				//Deletes the relation in "categoria_simples" (if it existed).
				$sql = "DELETE FROM categoria_simples WHERE nome = '$category';";
				$db->query($sql);

				//Deletes the relation in "super_categoria" (if it existed).
				$sql = "DELETE FROM super_categoria WHERE nome = '$category';";
				$db->query($sql);

				//Deletes the relation in "categoria".
				$sql = "DELETE FROM categoria WHERE nome = '$category';";
				$db->query($sql);

				break;

			case 3:
				$category_sub = $_POST["categoria_sub"];
				$category_super = $_POST["categoria_super"];
				
				$sql = "DELETE FROM categoria_simples VALUES ('$category_super');";
				$db->query($sql);

				$sql = "INSERT INTO super_categoria VALUES ('$category_super');";
				$db->query($sql);
				
				$sql = "INSERT INTO constituida VALUES ('$categoria_super', '$category_sub');";
				$db->query($sql);

				break;

			case 4:
				$category_sub = $_POST["categoria_sub"];

				//Gets the parent.
				$sql = "SELECT super_categoria FROM constituida WHERE categoria = '$category_sub';";
				$result = $db->query($sql);

				$parent = '';
				foreach ($result as $cat) {
					$parent = $cat['super_categoria'];
				}	

				$sql = "DELETE FROM constituida WHERE categoria = '$category_sub';";
				$db->query($sql);

				if ($parent != '') {
					$sql = "SELECT categoria FROM constituida WHERE super_categoria = '$parent';";
					$result = $db->query($sql);

					$children = array();
					foreach ($result as $cat) {
						$child = $cat['categoria'];
						array_push($children, $child);
					}
					if (sizeof($children) == 0) {
						$sql = "DELETE FROM super_categoria WHERE nome = '$parent';";
						$db->query($sql);
						$sql = "INSERT INTO categoria_simples VALUES ('$parent');";
						$db->query($sql);
					}
				}
				
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