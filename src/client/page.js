(function () {
    const confUrl = "/conf"
    $('body').append('<div>Current settings</div>')
    $.ajax(confUrl).then((data) => {
        console.log(data)
        render(JSON.parse(data))
    })

    const render = (data) => {
        const ts = data.ts * 1000
        $("<h3></h3>").text((new Date(ts)).toLocaleDateString() + " : " + (new Date(ts).toLocaleTimeString())).appendTo('body')
        const rules = data.rules

        const container = $("<div>").addClass("rules").appendTo('body')
        rules.forEach((rule) => {
            initRule(container, rule)
        })

        $("<div>Add more</div>")
            .click(() => {
                initRule(container, {h: 0, m: 0, br: 50})
            })
            .appendTo('body')

        $("<div>Save</div>")
            .click(save)
            .appendTo('body')
    }

    const lz = (val) => {
        if (val < 10) {
            return `${val}0`
        }
        return `${val}`
    }

    const initRule = (container, rule) => {
        const {h, m, br} = rule
        const $rule = $('<div>').addClass('rule').appendTo(container)
        const $time = $("<input>").addClass('time').appendTo($rule)
        $time.timepicker({
            timeFormat: 'H:i'
        })
        $time.timepicker('setTime', `${lz(h)}:${lz(m)}`)
        $("<input>")
            .attr({
                'class': 'br',
                'type': 'number',
                'value': br,
                'min': 0,
                'max': 100
            })
            .appendTo($rule)
            .on('change', (e) => {
                let val = Number(e.target.value)
                if (val > 100) {
                    val = 100
                }
                if (val < 0) {
                    val = 0
                }
                e.target.value = val
            })
        $("<span>").text('x').click(() => {
            $rule.remove()
        }).appendTo($rule)
    }

    const save = () => {
        const rules = []
        $(".rules .rule").each((ind, $rule) => {
            const timeStr = $($rule).find('.time').val()
            const percents = $($rule).find('.br').val()
            const [h, m] = timeStr.split(":")
            rules.push({
                h: Number(h), m: Number(m), br: Number(percents)
            })
        })

        $.ajax(confUrl, {
            data: JSON.stringify({
                rules: rules
            }),
            method: 'POST'
        })
            .then((res) => {
                const inf = $('<div>Saved</div>').addClass('note').appendTo('body')
                setTimeout(() => {
                    inf.remove()
                }, 2000)
            })
    }
})()