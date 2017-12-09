<html>
	<body>
		<h3>Inserir categoria</h3>
		<form action="case1_action.php" method="post">
			<p><input type="hidden" name="case" value="1"/></p>
			<p>Categoria a inserir: <input type="text" name="categoria"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Remover categoria</h3>
		<form action="case1_action.php" method="post">
			<p><input type="hidden" name="case" value="2"/></p>
			<p>Categoria a remover: <input type="text" name="categoria"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Inserir sub-categoria</h3>
		<form action="case1_action.php" method="post">
			<p><input type="hidden" name="case" value="3"/></p>
			<p>Sub-categoria a inserir: <input type="text" name="categoria_sub"/></p>
			<p>Super categoria na qual inserir: <input type="text" name="categoria_super"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

		<h3>Remover sub-categoria</h3>
		<form action="case1_action.php" method="post">
			<p><input type="hidden" name="case" value="4"/></p>
			<p>Sub-categoria a remover: <input type="text" name="categoria_sub"/></p>
			<p><input type="submit" value="Submit"/></p>
		</form>

	</body>
</html>
