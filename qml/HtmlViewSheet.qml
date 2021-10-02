import QtQuick 2.12
import QtWebEngine 1.10
import org.kde.kirigami 2.12 as Kirigami

Kirigami.OverlaySheet {
    property string subject
    property string html

    onHtmlChanged: {
        console.log("Loading HTML!");
        web.loadHtml(html);
    }

    WebEngineView {
        id: web

        height: 500
    }

    header: Kirigami.Heading {
        text: subject
    }

}
