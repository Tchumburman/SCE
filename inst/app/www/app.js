$(document).on('shown.bs.tab', function(e) {
  $(window).trigger('resize');
});

// ---- "Press [button] to get started" banners ----
var _hintDismissed = {};

function addStartHints() {
  var skip = ['Welcome', 'Quiz', 'References', 'Your Data'];

  $('.tab-pane.active:visible').each(function() {
    var $pane = $(this);

    // Only process leaf panes (no nested active sub-tabs inside)
    if ($pane.find('.tab-pane.active').length > 0) return;

    var paneId = $pane.attr('id') || '';
    var val    = $pane.attr('data-value') || '';
    if (skip.indexOf(val) >= 0) return;

    // Already has a hint or was dismissed
    var key = paneId || val;
    if (!key) return;
    if ($pane.find('.start-hint').length > 0) return;
    if (_hintDismissed[key]) return;

    // Find the primary action button (btn-success first, then any action button)
    var $btn = $pane.find('.btn-success').first();
    if (!$btn.length) $btn = $pane.find('.action-button').first();
    if (!$btn.length) return;

    var label = $.trim($btn.text()) || 'Run';

    var $hint = $('<div class="start-hint">' +
      '<i class="fa-solid fa-hand-pointer" style="opacity:0.45;margin-right:6px;"></i>' +
      'Press <strong>' + label + '</strong> to get started.</div>');

    // Insert at top of main content area (sidebar layout) or top of pane
    var $main = $pane.find('.bslib-sidebar-layout > .main').first();
    if ($main.length) {
      $main.prepend($hint);
    } else {
      $pane.prepend($hint);
    }

    // Dismiss on first click of that button
    (function(hint, k) {
      $btn.one('click', function() {
        _hintDismissed[k] = true;
        hint.fadeOut(400, function() { $(this).remove(); });
      });
    })($hint, key);
  });
}

// Fire on tab changes (main nav + sub-tabs) and after Shiny finishes processing
$(document).on('shown.bs.tab', function() {
  setTimeout(addStartHints, 300);
  setTimeout(addStartHints, 1200);
});
$(document).on('shiny:idle', function() {
  setTimeout(addStartHints, 400);
  setTimeout(addStartHints, 1500);
});

// ---- Reset start hints after memory cleanup ----
Shiny.addCustomMessageHandler('resetStartHints', function(tabValue) {
  var $mainPane = $('.tab-pane[data-value="' + tabValue + '"]');
  $mainPane.find('.tab-pane').addBack().each(function() {
    var k = $(this).attr('id') || $(this).attr('data-value') || '';
    if (k) delete _hintDismissed[k];
  });
  $mainPane.find('.start-hint').remove();
});

// ---- Detect dark mode ----
function isDark() {
  return document.documentElement.getAttribute('data-bs-theme') === 'dark';
}

// ---- Re-style plotly charts for dark / light ----
function restylePlotly() {
  var dark = isDark();
  var bg   = dark ? 'rgba(0,0,0,0)' : 'rgba(0,0,0,0)';
  var paper = dark ? 'rgba(0,0,0,0)' : 'rgba(0,0,0,0)';
  var gridC = dark ? 'rgba(147,161,161,0.12)' : 'rgba(101,115,131,0.12)';
  var fontC = dark ? '#839496' : '#657b83';
  var lineC = dark ? 'rgba(147,161,161,0.20)' : 'rgba(101,115,131,0.15)';

  document.querySelectorAll('.js-plotly-plot').forEach(function(el) {
    try {
      Plotly.relayout(el, {
        'paper_bgcolor': paper,
        'plot_bgcolor': bg,
        'font.color': fontC,
        'xaxis.gridcolor': gridC,
        'yaxis.gridcolor': gridC,
        'xaxis.linecolor': lineC,
        'yaxis.linecolor': lineC,
        'xaxis.zerolinecolor': gridC,
        'yaxis.zerolinecolor': gridC,
        'legend.bgcolor': 'rgba(0,0,0,0)',
        'legend.font.color': fontC
      });
    } catch(e) {}
  });
}

// ---- Watch for dark-mode toggle ----
$(document).ready(function() {

  // ---- Move hamburger toggler immediately after the home brand icon ----
  var $toggler = $('.navbar-toggler');
  var $brand   = $('.navbar-brand');
  if ($toggler.length && $brand.length) {
    $brand.after($toggler);
  }

  // ---- Pin icon buttons outside .navbar-collapse so they're always visible ----
  var pinnedIds = ['quiz_open', 'ud_open', 'ts_open', 'refs_open', 'guided_toggle', 'dark_toggle'];
  var $pinned = $('<div class="navbar-pinned-group"></div>');
  $.each(pinnedIds, function(_, id) {
    var $li = $('#' + id).closest('li.nav-item');
    if ($li.length) $pinned.append($li);
  });
  if ($pinned.children().length > 0) {
    $('.navbar-collapse').after($pinned);
  }
  // Watch for data-bs-theme change on <html>
  var themeObs = new MutationObserver(function(mutations) {
    mutations.forEach(function(m) {
      if (m.attributeName === 'data-bs-theme') {
        setTimeout(restylePlotly, 100);
      }
    });
  });
  themeObs.observe(document.documentElement, { attributes: true });

  // Also restyle plotly after any new plotly chart renders (debounced)
  var _plotlyTimer;
  var plotlyObs = new MutationObserver(function() {
    if (isDark()) {
      clearTimeout(_plotlyTimer);
      _plotlyTimer = setTimeout(restylePlotly, 400);
    }
  });
  plotlyObs.observe(document.body, { childList: true, subtree: true });

  // ---- Guided mode: auto-open explanations on tab change ----
  var _guidedTimer;
  var guidedObs = new MutationObserver(function() {
    if (document.body.classList.contains('guided-mode')) {
      clearTimeout(_guidedTimer);
      _guidedTimer = setTimeout(function() {
        document.querySelectorAll('.border-info .accordion-collapse:not(.show)').forEach(function(el) {
          var bsCollapse = bootstrap.Collapse.getOrCreateInstance(el, {toggle: false});
          bsCollapse.show();
        });
      }, 300);
    }
  });
  guidedObs.observe(document.body, { childList: true, subtree: true });
});
