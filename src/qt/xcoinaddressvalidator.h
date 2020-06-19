// Copyright (c) 2011-2014 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef XCOIN_QT_XCOINADDRESSVALIDATOR_H
#define XCOIN_QT_XCOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class XcoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit XcoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** Xcoin address widget validator, checks for a valid xcoin address.
 */
class XcoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit XcoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // XCOIN_QT_XCOINADDRESSVALIDATOR_H
