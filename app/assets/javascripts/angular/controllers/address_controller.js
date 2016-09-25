'use strict';

angular.module('geocoderApp').controller('addressController', addressController);
addressController.$inject = ['$http'];

function addressController($http) {
  var vm = this;
  vm.addressInfo = {country: null, area: null, address: null};

  vm.changePostalCode = function() {
    var promise = $http.get('/address_info', {postal_code: vm.postalCode});
    promise.success(function(data){
      vm.addressInfo = data;
    });
  };
}
