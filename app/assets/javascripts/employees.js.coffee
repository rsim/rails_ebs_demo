class EBS.EmployeesView

  constructor: ->
    (@$table = $("table"))
      .delegate("tr td.editable", "dblclick", @editRow)
      .delegate("a.cancel_edit", "click", @cancelEdit)
      .delegate(".buttons input:submit", "click", @save)

  editRow: (e) =>
    $td = $(e.currentTarget)
    $tr = $td.closest("tr")
    editableIndex = $tr.find("td.editable").index($td)
    $editTr = $tr.clone()
    $editTr.attr("id", "edit_" + $editTr.attr("id"))
    $editTr.find(".editable").each ->
      $this = $(this)
      $this.removeClass "editable"
      $input = $('<input type="text"/>')
      $input.attr "name", $this.attr("class")
      $input.attr "value", $this.data("value")
      $this.html $input
    $editTr.find(".buttons").html """
      <input type="submit" name="save" value="Save">
      <a href="#" class="cancel_edit">Cancel</a>
    """
    $editTr.insertAfter $tr
    $editTr.find("input:text").eq(editableIndex).focus()
    $tr.hide()
    false

  cancelEdit: (e) =>
    $target = $(e.currentTarget)
    $editTr = $target.closest("tr")
    $tr = $editTr.prev()
    $editTr.remove()
    $tr.show()
    false

  save: (e) =>
    $target = $(e.currentTarget)
    $target.val("Saving...").attr("disabled", true)
    $tr = $target.closest("tr")
    id = $tr.attr("id").split("_")[2]
    attributes =
      first_name: $tr.find("td.first_name input").val()
      last_name: $tr.find("td.last_name input").val()
      email_address: $tr.find("td.email_address input").val()
    $.ajax
      url: "/employees/#{id}"
      type: "PUT"
      contentType: "application/json"
      data: JSON.stringify(employee: attributes)
      dataType: "json"
      success: (data) => @saveSuccess($target, data)
      error: (xhr) => @saveError($target, xhr)
    false

  saveSuccess: ($target, data) =>
    $editTr = $target.closest("tr")
    $tr = $editTr.prev()
    $tr.find("td.editable").each ->
      $this = $(this)
      attr_name = $this.attr("class").split(' ')[1]
      value = data[attr_name]
      $this.text value
      $this.attr("data-value", value)
    $editTr.remove()
    $tr.show()

  saveError: ($target, xhr) =>
    $editTr = $target.closest("tr")
    if xhr.status = 422
      $editTr.find('.errors').remove()
      errors = JSON.parse(xhr.responseText)
      for attr_name, messages of errors
        $td = $editTr.find("td.#{attr_name}")
        $td.append """
          <div class="errors">
            #{messages.join(", ")}
          </div>
        """
        $td.find("input").focus()
    else
      alert("Saving failed with unknown error")
    $target.val("Save").removeAttr("disabled")
