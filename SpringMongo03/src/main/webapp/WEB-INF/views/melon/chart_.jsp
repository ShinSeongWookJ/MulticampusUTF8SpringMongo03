<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::멜론 차트 보기::</title>
<style>
#wrap {
	padding: 3em;
}
</style>

<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
//https://developers.google.com/chart/
	google.charts.load('current', {
		'packages' : [ 'corechart' ]
	});
	google.charts.setOnLoadCallback(drawChart);

	function drawChart() {

		data = new google.visualization.DataTable();
		data.addColumn('string', 'Topping');
		data.addColumn('number', 'Slices');
		data.addRows([ [ 'data1', 10 ], [ 'data2', 20 ], [ 'data3', 30 ],
				[ 'data4', 40 ], [ 'data5', 50 ] ]);

		var pie_options = {
			'title' : 'PIE TEST TITLE',
			'width' : 400,
			'height' : 300
		};

		var pie_chart = new google.visualization.PieChart(document
				.getElementById('piechart_div'));
		pie_chart.draw(data, pie_options);

		var bar_options = {
			'title' : 'BAR TEST TITLE',
			'width' : 400,
			'height' : 300
		};

		var bar_chart = new google.visualization.BarChart(document
				.getElementById('barchart_div'));
		bar_chart.draw(data, bar_options);
	}
</script>
<script>
//https://developers.google.com/chart/
	const getMelonCountBySinger = function() {
		data = new google.visualization.DataTable();
		data.addColumn('string', 'Singer');
		data.addColumn('number', 'SongCount');
		console.dir(data);
		let mydata=[];
		$.ajax({
			type : 'get',
			url : 'countBySinger',
			dataType : 'json',
			cache : false,
			success : function(res) {
				$.each(res, function(i, data) {
					if(i<20){
					let arr = [];
					arr.push(data.singer);
					arr.push(data.cntBySinger);
					
					mydata.push(arr);
					//data.addRows(mydata);
					}
					
				})
				console.log(mydata);
				data.addRows(mydata);
				$('#melonList').html("")
				renderChart(data);
			},
			error : function(err) {
				alert('err: ' + err.status);
			}
		});
	}//---------------------
	/* 구글 차트 옵션 설명
	https://sereni-ty.tistory.com/89
	var options = {     
title: '시간별 판매금액', 
fontSize: '12',
fontName: '굴림체',
hAxis: {
title: '시간', 
titleTextStyle: {color: 'red', fontName: '굴림체'}
} ,      
vAxis: {
title: '금액', 
titleTextStyle: {color: 'blue', fontName: '굴림체'}
} 
	*/
	const renderChart = function(data) {
		console.log("===renderChart()=========");
	
		var bar_options = {
			'title' : '차트에 오른 가수별 노래수',
			'width' : '70%',
			'height' : 900,
			'fontSize':'11',
			'fontName':'verdana',
			hAxis: {
				title: '노래수', 
				titleTextStyle: {color: 'red', fontName: '굴림체'}
				},      
			vAxis: {
				title: '가수', 
				titleTextStyle: {color: 'blue', fontName: '굴림체'}
			},
			colors:['#ec8f6e']
			//colors: ['#e0440e', '#e6693e', '#ec8f6e', '#f3b49f', '#f6c7b6']
		};

		var bar_chart = new google.visualization.BarChart(document
				.getElementById('barchart_div'));
		bar_chart.draw(data, bar_options);
	
	}
	$(function() {
		$('#btn1').on('click', function() {
			$.ajax({
				type : 'get',
				url : 'crawling',
				dataType : 'xml',
				cache : false,
				success : function(res) {
					//alert(res);//XML Document
					let n = $(res).find('result').text()
					//alert(n+"개의 데이터를 저장했습니다");
					$('#melonList').html("<h3>" + n + "개의 데이터를 크롤링했습니다</h3>");
					getMelonList();
				},
				error : function(err) {
					alert('err: ' + err.status);
				}
			})
		})//#bnt1 click------
	})//$() end----------------
	const getMelonList = function() {
		$.ajax({
			type : 'get',
			url : 'list',
			dataType : 'json',
			cache : false,
			success : function(res) {
				//alert(res);
				renderMelon(res)
			},
			error : function(err) {
				alert('err: ' + err.status);
			}
		});
	}//------------------------------------

	const renderMelon = function(jsonArr) {
		alert(jsonArr.length)
		let str = '<ul class="melon_chart">';
		$.each(jsonArr, function(i, obj) {
			str += '<li>';
			str += obj.ranking;
			str += '</li>';
			str += '<li>';
			str += '<img src="'+obj.albumImage+'">'
			str += '</li>';
			str += '<li>';
			str += '<span class="title">' + obj.songTitle + "</span><br>";
			str += '<span class="singer">' + obj.singer + "</span>"
			str += '</li>';
		});
		str += '</ul>';
		$('#melonList').html(str);
	}
</script>
</head>
<body>
	<div id="wrap" class="container">
		<h1>오늘의 Melon Chart - ${today}</h1>
		<button id="btn1">멜로 차트 크롤링하기</button>
		<button id="btn2" onclick="getMelonList()">멜론 차트 목록보기</button>
		<button id="btn3" onclick="getMelonCountBySinger()">멜론 차트 순위에
			오른 가수별 노래수</button>
		<div id="melonList"></div>
	</div>

	<div id="piechart_div"></div>
	<div id="barchart_div"></div>



</body>
</html>