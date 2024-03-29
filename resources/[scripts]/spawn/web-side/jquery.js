// -------------------------------------------------------------------------------------------
$(document).ready(() => {
	$(".buttonGroup > .buttonsBox > button").on("click",function(){
		$(this).parent().find("button").removeClass("active")
		$(this).addClass("active");
	});

	$(".spawnBox").on("click",function(){
		$(".spawnBox").removeClass("active");
		$(this).addClass("active");
	});

	function returnSeleted(type){
		return $(`#${type}`).find(".active").attr("id");
	}

	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("#charPage").css("display","block");
				$(".SpawnMessage").css("display","block");
				generateDisplay();
			break;

			case "closeSystem":
				$("#charPage").css("display","none");
				$(".SpawnMessage").css("display","none");
			break;

			case "openSpawn":
				generateSpawn();
			break;

			case "closeNew":
				$("#charPage").css("display","none");
				$(".SpawnMessage").css("display","none");
				$("#createPage").css("display","none");
			break;

			case "closeSpawn":
				$("#spawnPage").css("display","none");
			break;
		};
	});

	$(document).on("click",".charBox",function(e){
		$.post("http://spawn/characterChosen",JSON.stringify({ id: parseInt(e["currentTarget"]["dataset"]["id"]) }));
		$("#charPage").css("display","none");
		$(".SpawnMessage").css("display","none");
	});

	$(document).on("click",".charNew",function(e){
		$("#charPage").css("display","none");
		$(".SpawnMessage").css("display","none");
		$("#createPage").css("display","block");
	});

	$(document).on("click","#createBack",function(e){
		$("#charPage").css("display","block");
		$(".SpawnMessage").css("display","block");
		$("#createPage").css("display","none");
	});

	$(document).on("click",".spawnBox",function(e){
		$.post("http://spawn/spawnChosen",JSON.stringify({ hash: parseInt(e["currentTarget"]["dataset"]["hash"]) }));
	});

	$(document).on("click","#spawnNew",function(e){
		$.post("http://spawn/spawnChosen",JSON.stringify({ hash: "spawn" }));
	});

	$(document).on("click","#createNew",function(e){
		var name = $("#charNome").val();
		var name2 = $("#charSobrenome").val();
		var gender = returnSeleted("gender");
		var locate = returnSeleted("locate");

		if (name != "" && name2 != ""){
			$.post("http://spawn/newCharacter",JSON.stringify({ name: name, name2: name2, sex: gender, locate: locate }));
		}
	});
});

const generateDisplay = () => {
	$.post("http://spawn/generateDisplay",JSON.stringify({}),(data) => {

		var characterList = data["result"].sort((a,b) => (a["Passport"] > b["Passport"]) ? 1 : -1);

		$("#charPage").html(`
			<div class="charNew"><p>NOVO PERSONAGEM</p><o>Criar um novo personagem</o></div>

			${characterList.map((item) => (`
				<div class="charBox" data-id="${item["Passport"]}">
					<div class="playerInfo">
						<p><b>Nome:</b> ${item["Nome"]}</p>
						<p><b>Sexo:</b> ${item["Sexo"] === "M" ? "Masculino":"Feminino"}</p>
						<p><b>Nacionalidade:</b> ${item["Local"]}</p>
						<p><b>Tipo Sangüineo:</b> ${item["Sangue"]}</p>
					</div>

					<div class="playerButton">
						<i class="mdi mdi-arrow-up-bold-circle"></i>
					</div>
			</div>`)).join("")}
		`);
	});
}

const generateSpawn = () => {
	$.post("http://spawn/generateSpawn",JSON.stringify({}),(data) => {
		var characterList = data["result"].sort((a,b) => (a["name"] > b["name"]) ? 1 : -1);

		$("#spawnPage").html(`
			${characterList.map((item) => (`
				<div class="spawnBox" data-hash="${item["hash"]}">
					${item["name"]}
				</div>`)).join("")}

			<div id="spawnNew" data-hash="spawn">Confirmar</div>
		`);

		$("#spawnPage").css("display","block");
	});
}