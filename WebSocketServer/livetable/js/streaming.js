angular.module('myApp', [])
	.controller('recordsCtrl', ["$scope","$http", function($scope, $http) {
		var ws;
		$scope.status = "IDLE";
		$scope.records = [];
		
		ws = new WebSocket("ws://"+window.location.host+"/livetable/livetable.dyalog");
		ws.onopen = function(evt) 		{ 
			$scope.status = "CONNECTED"; 
			$scope.$apply();
		};
		ws.onclose = function(evt) 	{ $scope.status = "DISCONNECTED";  };
		ws.onmessage = function(evt) 	{ 
			var records = JSON.parse(evt.data);
			$scope.records = records; 
			$scope.$apply();
		};
		ws.onerror = function(evt) 	{ $scope.status = "ERROR: " + evt.data };
		
	}]);
