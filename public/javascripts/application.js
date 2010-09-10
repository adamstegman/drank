/**
 * Requests fresh data from the server. Calls callback with the response text.
 *
 * @param {Function} callback The Function to call with the response text.
 */
function requestFreshData(callback) {
  var xhr = new XMLHttpRequest();
  xhr.open("GET", "/", true);
  xhr.setRequestHeader("Accept", "application/json");
  xhr.setRequestHeader("Connection", "close");
  xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) callback(xhr.responseText);
  }
  xhr.send();
  setTimeout("requestFreshData(updateCounts)", 300000);
}

/**
 * Updates the "drank" counts on the page.
 *
 * @param {String} people_string JSON string representing the people Objects
 *                               on the page.
 */
function updateCounts(people_string) {
  var people = JSON.parse(people_string);
  // Find each person's drank cell and replace the text with the new count.
  for (var i = 0, l = people.length; i < l; i++) {
    var person = people[i].person,
        cell = document.getElementById("drank-" + person.id);
    while (cell.hasChildNodes()) {
      cell.removeChild(cell.lastChild);
    }
    cell.appendChild(document.createTextNode(person.drank));
  }
}

// Refresh the data once, setting the timer for it to go off indefinitely.
if (JSON && JSON.parse) {
  requestFreshData(updateCounts);
}