function highlight()
{
  var items = new Array();
  var queryTermsRegExp = new RegExp('q=([^&]+)');
  if (queryTermsRegExp.test(location.href))
  {
    items = RegExp.$1.split('+');
  }
  var colors = new Array('#ffff66', '#a0ffff', '#99ff99', '#ff9999', '#ff66ff',
                         '#880000', '#00aa00', '#886800', '#004699', '#990099');
  b = document.getElementById('middle').innerHTML;
  for (var i=0; i < items.length; i++)
  {
   var replacementRegEx = new RegExp('(' + items[i] + ')','gi');
   b = b.replace(replacementRegEx,'<span style=\'background-color:' + colors[i % colors.length] + ';\'>$1</span>');
  }
  if(items.length > 0)
  {
    var scrollToRegEx = new RegExp('(' + items[0] + ')','i');
    b = b.replace(scrollToRegEx, '<span id=\'scrollToHilight\'>$1</span>');
    document.getElementById('center').innerHTML = b;
    window.scrollTo(0,document.getElementById('scrollToHilight').offsetTop);
  }
}