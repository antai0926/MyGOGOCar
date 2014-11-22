<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/_00_fragment/css.jsp" />
<title>Goo-go</title>

<!-- Google Map Start-->
<style>
#map-canvas {
	height: 280px;
	width: 100%;
	margin: 10px;
	padding: 10px;
}
</style>
<script
	src="https://maps.googleapis.com/maps/api/js?v=3.exp&language=zh-TW"></script>
<script>
// 用此程式需要從後端傳入以下:comAdressArray、comNameArray、rowsPerPage、whichPage、location(可參考reserch.jsp)
	function initialize() {
		initMapCenter();
	}//end function initialize()

	var comAdressArray = <%=request.getAttribute("comAdressArray")%>; //公司地址陣列
	var comNameArray =<%=request.getAttribute("comNameArray")%>;//公司名稱陣列
	function setMarkers(map, locations) {

		var image = {
			url : 'images/icon1.jpg',
			// This marker is 20 pixels wide by 32 pixels tall.
			size : new google.maps.Size(109, 106),
			// The origin for this image is 0,0.
			origin : new google.maps.Point(0, 0),
			// The anchor for this image is the base of the flagpole at 0,32.
			anchor : new google.maps.Point(0, 32)
		};

		var shape = {
			coords : [ 1, 1, 1, 20, 18, 20, 18, 1 ],
			type : 'poly'
		};
		var beach = locations;
		var myLatLng = new google.maps.LatLng(beach[1], beach[2]);
		var marker = new google.maps.Marker({
			position : myLatLng,
			map : map,
			// icon: image,
			shape : shape,
			title : beach[0],
		//zIndex : beach[3]
		});
	}//end function setMarkers(map, locations)
	function addressToLatLng(comName,addr, map) {//將中文地址轉為經緯度
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode({
			"address" : addr
		}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var coordinate = [comName, results[0].geometry.location.lat(),
						results[0].geometry.location.lng() ]
				setMarkers(map, coordinate);
				//alert(position);
			} else {
				alert("查無經緯度");
			}
		});//end  geocoder.geocode
	}//end function addressToLatLng(addr) 
	function showTaiwan(){
		 var mapOptions = {
					zoom : 7, //zoom:10, 越大顯示區域越小(精細)
					center : new google.maps.LatLng(23.58, 121.00)
				}
		 var map = new google.maps.Map(document.getElementById('map-canvas'),
					mapOptions);
		 return map;
	}
	function findComMarkers(map) {
		if(comAdressArray.length==0){//若沒有商家地址資料
			showTaiwan();
		    alert("沒有商家地址資料");
		   //這地方要加入處理顯示沒有商家資料利用jQuery?
		   return;
		}
		var rowsPerPage = <%=request.getAttribute("rowsPerPage")%>;
		var whichPage= <%=request.getAttribute("whichPage")%>;//此頁第幾頁
		//alert("rowsPerPage="+rowsPerPage);
		//alert("whichPage="+whichPage);
		var startIndex=(whichPage-1)*rowsPerPage;//該頁起始筆數
		var endIndex = (whichPage*rowsPerPage-1); //該頁終止筆數
		if((comAdressArray.length-1)<endIndex){//當最後一頁顯示筆數不足rowsPerPage
			endIndex = comAdressArray.length-1; //則將剩餘的顯示
		}
		for (var i = startIndex; i <= endIndex ; i++) {	
			addressToLatLng(comNameArray[i],comAdressArray[i], map); //傳入地址陣列
		}
	}
	function initMapCenter(){ //先查詢縣市初步位置再將中心點設置在該地區
		var addr = comAdressArray[0]; //改了這裡偷吃步整個程式還需改善
		//搜尋時地區沒有設值
		if("<%=request.getAttribute("location")%>" == "null") {
			findComMarkers(showTaiwan());
			return;
		} else { //進入此else表示有根據地區搜尋
			var geocoder = new google.maps.Geocoder();
			geocoder.geocode({
				"address" : addr
			}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK) {
					var mapOptions = {
						zoom : 15, //zoom:10, 越大顯示區域越小(精細)
						center : new google.maps.LatLng(
								results[0].geometry.location.lat(),
								results[0].geometry.location.lng())
					//center : new google.maps.LatLng(-33.890542, 151.274856)
					}
					var map = new google.maps.Map(document
							.getElementById('map-canvas'), mapOptions);
					findComMarkers(map);
					//alert(position);
				} else {//代表地址轉換成經緯度失效
					alert("無法初始地圖中心點");
					showTaiwan(); //只show出台灣地圖
				}
			});//end  geocoder.geocode			
		}//end else 進入此else表示有根據地區搜尋	
	}//end function initMapCenter()
	google.maps.event.addDomListener(window, 'load', initialize);
</script>
<!-- Google Map End-->


</head>
<body>
	<!-- top1 -->
	<jsp:include page="/_00_fragment/top1.jsp" />

	<!-- Page Content -->
	<div class="container">

		<!-- Page Heading/Breadcrumbs -->
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">
					<!-- 				在此comVO是用振瑋的VO -->
					${comVO.comName} <small>租車小舖</small>
				</h1>
			</div>
		</div>
		<!-- /.row -->

		<!-- Intro Content -->
		<div class="row">
			<!-- 店家圖片 -->
			<div class="col-md-6">
				<img class="img-responsive"
					src='${pageContext.servletContext.contextPath}/image?comID=${comId}'
					alt="">
			</div>
			<!-- /店家圖片 -->
			<div class="col-md-6">
				<div class="col-lg-12">
					<!-- 標籤 -->
					<ul id="myTab" class="nav nav-tabs nav-justified">
						<li class="active"><a href="#service-one" data-toggle="tab"><i
								class="fa fa-tag"></i> 店家位置</a></li>
						<li class=""><a href="#service-two" data-toggle="tab"><i
								class="fa  fa-phone"></i> 店家資訊</a></li>
						<li class=""><a href="#service-three" data-toggle="tab"><i
								class="fa fa-book"></i> 優惠方案</a></li>
					</ul>
					<!-- /標籤 -->
					<!-- 標籤內容 -->
					<div id="myTabContent" class="tab-content">
						<div class="tab-pane fade active in" id="service-one">
							<div id="map-canvas"></div>
						</div>
						<div class="tab-pane fade" id="service-two">
							<ul>
								<li><h3>地址:${comVO.comAddr}</h3></li>
								<li><h3>Service One</h3></li>
								<li><h3>Service One</h3></li>
								<li><h3>Service One</h3></li>
							</ul>
						</div>
						<div class="tab-pane fade" id="service-three">
							<h4>Service</h4>
							<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.
								Quae repudiandae fugiat illo cupiditate excepturi esse officiis
								consectetur, laudantium qui voluptatem. Ad necessitatibus velit,
								accusantium expedita debitis impedit rerum totam id. Lorem ipsum
								dolor sit amet, consectetur adipisicing elit. Natus quibusdam
								recusandae illum, nesciunt, architecto, saepe facere, voluptas
								eum incidunt dolores magni itaque autem neque velit in. At quia
								quaerat asperiores.</p>
							<a href="#accessoriesRoW">配件配件配件</a>
						</div>
					</div>
					<!-- /標籤內容 -->
				</div>
			</div>
		</div>
		<!-- /.row -->

		<!-- Team Members -->
		<div class="row">
			<div class="col-lg-12">
				<h2 class="page-header">商品</h2>
			</div>
			<!-- 標籤 -->
			<div class="col-lg-12">
				<ul id="prodsTab" class="nav nav-tabs nav-justified">
					<c:if test="${hasCar == 1}">
						<li class="active"><a href="#car-content" data-toggle="tab"><i
								class="fa fa-car"></i> 汽車</a></li>
					</c:if>
					<c:if test="${hasMotor == 1}">
						<li class=""><a href="#mortor-content" data-toggle="tab"><i
								class="fa fa-phone"></i> 機車</a></li>
					</c:if>
					<c:if test="${hasBike == 1}">
						<li class=""><a href="#bike-content" data-toggle="tab"><i
								class="fa fa-bicycle"></i> 腳踏車</a></li>
					</c:if>
				</ul>
			</div>
			<!-- /標籤 -->
			<!-- 標籤內容 -->
			<div id="prodsTabContent" class="tab-content">
				<div class="tab-pane fade active in" id="car-content">
					<!-- 			foreach也還是遵照Java index從0開始，因為Java物件從後端丟到這裡 -->
					<c:forEach var="ProductVO" items="${prodsVos}" begin="0"
						end="${prodsVos.size()-1}">
						<c:if test="${ProductVO.prodType == 1}">
							<!-- 車車1 -->
							<div class="col-md-4 text-center">
								<div class="thumbnail">
									<a href="" data-toggle="modal" data-target="#prod_detail">
										<img class="img-responsive"
										src='${pageContext.servletContext.contextPath}/ComFirstPageImg?comID=${comId}&prodId=${ProductVO.prodId}'
										alt="">
										<div class="caption">
											prodid = ${ProductVO.prodId} prodType = ${ProductVO.prodType}
											<h3>${ProductVO.prodName}</h3>
											<p>Lorem ipsum dolor sit amet, consectetur adipisicing
												elit. Iste saepe et quisquam nesciunt maxime.</p>
										</div>
									</a>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<!-- car content -->
				<div class="tab-pane fade " id="mortor-content">
					<c:forEach var="ProductVO" items="${prodsVos}" begin="0"
						end="${prodsVos.size()-1}">
						<c:if test="${ProductVO.prodType == 2}">
							<!-- 機車2 -->
							<div class="col-md-4 text-center">
								<div class="thumbnail">
									<a href="" data-toggle="modal" data-target="#prod_detail">
										<img class="img-responsive"
										src='${pageContext.servletContext.contextPath}/ComFirstPageImg?comID=${comId}&prodId=${ProductVO.prodId}'
										alt="">
										<div class="caption">
											prodid = ${ProductVO.prodId}
											<h3>${ProductVO.prodName}</h3>
											<p>Lorem ipsum dolor sit amet, consectetur adipisicing
												elit. Iste saepe et quisquam nesciunt maxime.</p>
										</div>
									</a>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<!-- motor content -->
				<div class="tab-pane fade" id="bike-content">
					<c:forEach var="ProductVO" items="${prodsVos}" begin="0"
						end="${prodsVos.size()-1}">
						<c:if test="${ProductVO.prodType == 3}">
							<!-- 腳踏車3 -->
							<div class="col-md-4 text-center">
								<div class="thumbnail">
									<a href="" data-toggle="modal" data-target="#prod_detail">
										<img class="img-responsive"
										src='${pageContext.servletContext.contextPath}/ComFirstPageImg?comID=${comId}&prodId=${ProductVO.prodId}'
										alt="">
										<div class="caption">
											prodid = ${ProductVO.prodId}
											<h3>${ProductVO.prodName}</h3>
											<p>Lorem ipsum dolor sit amet, consectetur adipisicing
												elit. Iste saepe et quisquam nesciunt maxime.</p>
										</div>
									</a>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</div>
				<!-- motor content -->
			</div>
			<!-- /標籤內容 -->
		</div>
		<!-- /.row -->

		<!-- 配件 -->
		<div class="row" id="accessoriesRoW">
			<div class="col-lg-12">
				<h2 class="page-header">配件</h2>
			</div>
			<!-- 配件1 500*400-->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/25.jpg" alt="">
					<div class="caption">
						<h4>安全帽</h4>
					</div>
				</div>
			</div>
			<!-- 配件2 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/32.jpg" alt="">
					<div class="caption">
						<h4>兒童安全座椅</h4>
					</div>
				</div>
			</div>
			<!-- 配件3 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/26.jpg" alt="">
					<div class="caption">
						<h4>衝浪板</h4>
					</div>
				</div>
			</div>
			<!-- 配件4 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/27.jpg" alt="">
					<div class="caption">
						<h4>野餐用具</h4>
					</div>
				</div>
			</div>
			<!-- 配件5 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/28.jpg" alt="">
					<div class="caption">
						<h4>帳篷</h4>
					</div>
				</div>
			</div>
			<!-- 配件6 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/29.jpg" alt="">
					<div class="caption">
						<h4>游泳圈</h4>
					</div>
				</div>
			</div>
			<!-- 配件7 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/30.jpg" alt="">
					<div class="caption">
						<h4>滑板</h4>
					</div>
				</div>
			</div>
			<!-- 配件8 -->
			<div class="col-md-3 col-sm-6">
				<div class="thumbnail">
					<img class="img-responsive"
						src="${pageContext.request.contextPath}/img/31.jpg" alt="">
					<div class="caption">
						<h4>遊樂園門票</h4>
					</div>
				</div>
			</div>
		</div>
		<!-- /.配件 -->
		<!-- 商品明細 -->
		<jsp:include page="/_05_company/prod_detail.jsp" />
		<hr>
		<!-- Footer -->
		<jsp:include page="/_00_fragment/footer.jsp" />

	</div>
	<!-- /.container -->

	<script src="${pageContext.request.contextPath}/js/jquery-1.11.0.js"></script>
	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>

</body>
</html>