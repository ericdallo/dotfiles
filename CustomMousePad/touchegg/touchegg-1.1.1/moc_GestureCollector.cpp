/****************************************************************************
** Meta object code from reading C++ file 'GestureCollector.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "src/touchegg/gestures/collector/GestureCollector.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'GestureCollector.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_GestureCollector[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: signature, parameters, type, tag, flags
      18,   17,   17,   17, 0x05,
      40,   26,   17,   17, 0x05,
      97,   26,   17,   17, 0x05,
     155,   26,   17,   17, 0x05,

 // slots: signature, parameters, type, tag, flags
     215,  213,   17,   17, 0x0a,
     233,  213,   17,   17, 0x0a,
     254,   17,   17,   17, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_GestureCollector[] = {
    "GestureCollector\0\0ready()\0type,id,attrs\0"
    "executeGestureStart(QString,int,QHash<QString,QVariant>)\0"
    "executeGestureUpdate(QString,int,QHash<QString,QVariant>)\0"
    "executeGestureFinish(QString,int,QHash<QString,QVariant>)\0"
    "w\0addWindow(Window)\0removeWindow(Window)\0"
    "geisEvent()\0"
};

void GestureCollector::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        GestureCollector *_t = static_cast<GestureCollector *>(_o);
        switch (_id) {
        case 0: _t->ready(); break;
        case 1: _t->executeGestureStart((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 2: _t->executeGestureUpdate((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 3: _t->executeGestureFinish((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< const QHash<QString,QVariant>(*)>(_a[3]))); break;
        case 4: _t->addWindow((*reinterpret_cast< Window(*)>(_a[1]))); break;
        case 5: _t->removeWindow((*reinterpret_cast< Window(*)>(_a[1]))); break;
        case 6: _t->geisEvent(); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData GestureCollector::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject GestureCollector::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_GestureCollector,
      qt_meta_data_GestureCollector, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &GestureCollector::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *GestureCollector::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *GestureCollector::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_GestureCollector))
        return static_cast<void*>(const_cast< GestureCollector*>(this));
    return QObject::qt_metacast(_clname);
}

int GestureCollector::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    return _id;
}

// SIGNAL 0
void GestureCollector::ready()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void GestureCollector::executeGestureStart(const QString & _t1, int _t2, const QHash<QString,QVariant> & _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void GestureCollector::executeGestureUpdate(const QString & _t1, int _t2, const QHash<QString,QVariant> & _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void GestureCollector::executeGestureFinish(const QString & _t1, int _t2, const QHash<QString,QVariant> & _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_END_MOC_NAMESPACE
