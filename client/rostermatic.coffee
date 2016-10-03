
expand = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\*(.+?)\*/g, '<i>$1</i>'

facts = (site) ->
  items = []
  items.push ( (Date.now() - site.birth) / 1000 / 3600 / 24 / 31.5 ).toFixed(1) if site.birth
  items.push 'owner' if site.owner
  items.push 'persona' if site.persona
  items.push 'openid' if site.openid
  """<span style="float:right">#{items.reverse().join ', '}</span>"""

report = (sites) ->
  result = []
  for site in sites
    if site.birth?
      d = site.file
      a = "#{d}:#{location.port}"
      result.push """
        <img
          class=remote
          src="//#{a}/favicon.png"
          title=#{d}
          data-site=#{d}
          data-slug=welcome-visitors>
        #{d}
        #{facts site}
      """
  result.join "<br>\n"

emit = ($item, item) ->
  $item.append """<p style="background-color:#eee;padding:15px;">"""
  $.getJSON '/plugin/rostermatic/sites', (data) ->
    $item.find('p').html report data.sites

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.rostermatic = {emit, bind} if window?
module.exports = {expand} if module?

