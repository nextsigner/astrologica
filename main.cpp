#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "unikqprocess.h"
#include "unik.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName("AstroLogica");
    app.setApplicationName("AstroLogica");
    app.setApplicationVersion("0.1");
    app.setWindowIcon(QIcon("./icon.png"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("./main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    qmlRegisterType<UnikQProcess>("unik.UnikQProcess", 1, 0, "UnikQProcess");
    Unik u;
    engine.rootContext()->setContextProperty("unik", &u);
    engine.load(url);

    return app.exec();
}
