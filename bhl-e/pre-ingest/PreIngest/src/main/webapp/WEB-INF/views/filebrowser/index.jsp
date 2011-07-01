<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<script type='text/javascript'>
  $(function(){
    $("form").submit(function() {
      // Serialize standard form fields:
      var formData = $(this).serializeArray();

      // then append Dynatree selected 'checkboxes':
      var tree = $("#tree").dynatree("getTree");
      formData = formData.concat(tree.serializeArray());

      // and/or add the active node as 'radio button':
      if(tree.getActiveNode()){
        formData.push({name: "activeNode", value: tree.getActiveNode().data.key});
      }

      // alert("POSTing this:\n" + jQuery.param(formData));

      $.post("sendNodes",
           formData,
           function(response, textStatus, xhr){
             // alert("POST returned " + response + ", " + textStatus);
           }
      );
      return false;
    });
});
</script>
<!-- Add a <div> element where the tree should appear: -->
<form method="POST" action="submitNodes">
  OCR-Language: <input type="text" name="lang" maxlength="3"><br>
  Select folders to be processed:
  <br>
  <!-- The name attribute is used by tree.serializeArray()  -->
  <div id="tree" id="selNodes" name="selNodes">
  </div>
  <br>
  <input type="submit" value="Send data">
</form>
 