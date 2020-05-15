import React, {Fragment} from 'react';
import {ActionCable} from 'react-actioncable-provider';

const CatCable = ({cats, handleReceivedMessage}) => {
    return (
        <Fragment>
            <ActionCable
                key={'test'}
                channel={{channel: 'MessagesChannel', conversation: 'test'}}
                onReceived={handleReceivedMessage}
            />
        </Fragment>
    );
};

export default CatCable;