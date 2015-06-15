/****************************************************************************
** Meta object code from reading C++ file 'GestureHandler.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "src/touchegg/gestures/handler/GestureHandler.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'GestureHandler.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_GestureHandler[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      30,   16,   15,   15, 0x0a,
      87,   16,   15,   15, 0x0a,
     145,   16,   15,   15, 0x0a,
     203,   15,   15,   15, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_GestureHandler[] = {
    "GestureHandler\0\0type,id,attrs\0"
    "executeGestureStart(QString,int,QHash<QString,QVariant>)\0"
    "executeGestureUpdate(QString,int,QHash<QString,QVariant>)\0"
    "executeGestureFinish(QString,int,QHash<QString,QVariant>)\0"
    "executeTap()\0"
};

void GestureHandler::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        GestureHandler *_t = static_cast<GestureHandler *>(_o);
        switch (_id) {
        case 0: _t->executeGestureStart((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 1: _t->executeGestureUpdate((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 2: _t->executeGestureFinish((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 3: _t->executeTap(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData GestureHandler::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject GestureHandler::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_GestureHandler,
      qt_meta_data_GestureHandler, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &GestureHandler::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *GestureHandler::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *GestureHandler::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_GestureHandler))
        return static_cast<void*>(const_cast< GestureHandler*>(this));
    return QObject::qt_metacast(_clname);
}

int GestureHandler::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
