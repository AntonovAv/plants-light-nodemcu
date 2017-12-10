(function () {
    $('body').append('<div>Current settings</div>')
    $.ajax("http://192.168.0.8/conf").then((data) => {
        console.log(data)
        render(JSON.parse(data))
    })

    const render = function (data) {
        const ts = data.ts * 1000
        $("<h3></h3>").text((new Date(ts)).toLocaleDateString() + " : " + (new Date(ts).toLocaleTimeString())).appendTo('body')
        const rules = data.rules

        const container = $("<div>").addClass("rules").appendTo('body')
        rules.forEach((rule) => {
            initRule(container, rule)
        })

        $("<div>Add more</div>").on('click', () => {
            initRule(container, {h: 0, m: 0, br: 50})
        }).appendTo('body')
    }

    const lz = (val) => {
        if (val < 10) {
            return `${val}0`
        }
        return `${val}`
    }

    const initRule = function (container, rule) {
        const {h, m, br} = rule
        const $rule = $('<div>').addClass('rule').appendTo(container)
        const $time = $("<input>").addClass('time').appendTo($rule)
        $time.timepicker({
            timeFormat: 'H:i'
        })
        $time.timepicker('setTime', `${lz(h)}:${lz(m)}`)
        $("<input>").addClass('br').attr('value', br).appendTo($rule)
        $("<span>").text('x').click(() => {$rule.remove()}).appendTo($rule)
    }
})()