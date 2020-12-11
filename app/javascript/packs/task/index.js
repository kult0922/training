$('#select-sort').on('change',function(e){
  var selectedSortNo = $(this).val();
  console.log(selectedSortNo);

  if(selectedSortNo == 2){
    location.href = '/2';
  }
  else{
    location.href = '/';
  }
})
