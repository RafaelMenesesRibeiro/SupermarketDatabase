<html>
	<body>
		<h3>Inserir produto</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="1"/></p>
			<p>EAN do produto a inserir: <input type="text" name="ean"/></p>
			<p>EAN do produto a inserir: <input type="text" name="designation"/></p>
			<p>EAN do produto a inserir: <input type="text" name="category"/></p>
			<p>EAN do produto a inserir: <input type="text" name="forn_priamrio"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Remover produto</h3>
		<form action="case2_action.php" method="post">
			<p><input type="hidden" name="case" value="2"/></p>
			<p>Categoria a remover: <input type="text" name="categoria"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>
	</body>
</html>
