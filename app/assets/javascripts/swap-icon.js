// $.fn.swapIcon = function(iconName) {
//   this.each(function() {
//     var $el = $(this);
//     var classes = $el.attr("class").split(" ");
//     var newClasses = $.map(classes, function(cssClass) {
//       if(!cssClass.match(/^icon\-.+$/)) {
//         return cssClass;
//       }
//     });
//     var newIconClass = ("icon-" + iconName);
//     newClasses.push(newIconClass);
//     $el.removeClass().addClass(newClasses.join(" "));
//   });
// };
$.fn.swapIcon = function(firstIconName, secondIconName) {
  this.each(function() {
    var $el = $(this);
    var firstIconClass = "icon-" + firstIconName;
    var secondIconClass = "icon-" + secondIconName;
    if($el.hasClass(firstIconClass)) {
      $el.removeClass(firstIconClass).addClass(secondIconClass);
    } else {
      $el.removeClass(secondIconClass).addClass(firstIconClass);
    }
  });
};