angular.module('myApp', [])
	.controller('recordsCtrl', ["$scope","$http", function($scope, $http) {
		var ws;
		$scope.status = "IDLE";
		$scope.table_name = "";
		$scope.table_rows = [];
		
		ws = new WebSocket("ws://"+window.location.host+"/livetable/tables");
		ws.onopen = function(evt) 		{ 
			$scope.status = "CONNECTED"; 
			$scope.$apply();
		};
		ws.onclose = function(evt) 	{ $scope.status = "DISCONNECTED";  };
		ws.onmessage = function(evt) 	{ 
			var msg = JSON.parse(evt.data);
			$scope.table_name = msg.table_name; 
			$scope.table_rows = msg.table_rows; 
			$scope.$apply();
		};
		ws.onerror = function(evt) 	{ $scope.status = "ERROR: " + evt.data };
		
	}]);
