#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMetaType>
#include <QtWebEngine>

#include "accounts.h"
#include "message.h"
#include "chat.h"
#include "chatlist.h"
#include "context.h"
#include "contact.h"
#include "eventemitter.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    QtWebEngine::initialize();
    QGuiApplication app(argc, argv);

    app.setApplicationName("KDeltaChat");
    app.setOrganizationName("KDeltaChat");
    app.setOrganizationDomain("delta.chat");

    // TODO: switch to using Qt 5.15 QML_ELEMENT macro
    if (qmlRegisterType<DcAccounts>("DeltaChat", 1, 0, "DcAccounts") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<Context>("DeltaChat", 1, 0, "DcContext") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcChatlist>("DeltaChat", 1, 0, "DcChatlist") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcChat>("DeltaChat", 1, 0, "DcChat") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcMessage>("DeltaChat", 1, 0, "DcMessage") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcContact>("DeltaChat", 1, 0, "DcContact") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcLot>("DeltaChat", 1, 0, "DcLot") == -1)
      {
        QCoreApplication::exit(-1);
      }
    if (qmlRegisterType<DcAccountsEventEmitter>("DeltaChat", 1, 0, "DcAccountsEventEmitter") == -1)
      {
        QCoreApplication::exit(-1);
      }
    qRegisterMetaType<size_t>("size_t");
    qRegisterMetaType<uint32_t>("uint32_t");
    qRegisterMetaType<QVector<uint32_t>>("QVector<uint32_t>");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
