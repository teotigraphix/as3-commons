package org.as3commons.async.operation {

import org.as3commons.async.ICancelable;

/**
 * Marker interface for <code>IOperation</code> that can be cancelled.
 */
public interface ICancelableOperation extends IOperation, ICancelable {
}
}
