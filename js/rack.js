jQuery('.run-example span').click(function(e) {
  result_div = $(this).data('result')
  url = $(this).data('url')
  jQuery.get(url, function(data, textStatus, jqXHR) {
    console.log(jqXHR.getResponseHeader('Content-Length'))
    status = '<div>Status: ' + jqXHR.status + '</div>'
    headers = '<div>Headers: ' + jqXHR.getResponseHeader('Content-Length') + '</div>'
    content = '<div>Content: ' + data + '</div>'

    $(result_div).html(status + headers + content)
  });
});
