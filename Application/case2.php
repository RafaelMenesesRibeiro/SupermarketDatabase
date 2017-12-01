<html>
	<body>
		<h3>Inserir produto</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="1"/></p>
			<p>EAN do produto a inserir: <input type="text" name="ean"/></p>
			<p>Designacao do produto a inserir: <input type="text" name="designation"/></p>
			<p>Categoria do produto a inserir: <input type="text" name="category"/></p>
			<p>NIF do fornecedor primario do produto a inserir: <input type="text" name="nif"/></p>
			<p>Data do fornecedor primario do produto a inserir (yyyy-mm-dd): <input type="text" name="date"/></p>

			<div id="secondary_suppliers">
				<p>NIF de fornecedor secundario 1: <input type="text" name="secondary1"/></p>
			</div>
		
			<p><input type="submit" value="Submit"/></p>
		</form>
		<button onclick="addSecondary()">Add secondary supplier slot</button>

		<h3>Remover produto</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="2"/></p>
			<p>EAN do produto a inserir: <input type="text" name="ean"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Inserir fornecedor</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="3"/></p>
			<p>NIF do fornecedor: <input type="text" name="nif"/></p>
			<p>Nome do fornecedor: <input type="text" name="name"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Remover fornecedor</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="4"/></p>
			<p>NIF do fornecedor: <input type="text" name="nif"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

	</body>

	<script type="text/javascript">
		var i = 1;

		function addSecondary() {
			i++;
			var container = document.createElement("p");
			var node = document.createTextNode("NIF de fornecedor secundario " + i + " : ");
			container.appendChild(node);

			var input = document.createElement("input");
			input.type = "text";
			input.name = "secondary" + i;
		
			container.appendChild(input);
			document.getElementById('secondary_suppliers').appendChild(container);
		}
	</script>
</html>
