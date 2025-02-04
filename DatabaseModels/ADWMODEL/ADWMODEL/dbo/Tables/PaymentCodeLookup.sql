CREATE TABLE [dbo].[PaymentCodeLookup] (
    [PaymentCodeId]     INT           NOT NULL,
    [PaymentCd]         CHAR (3)      NOT NULL,
    [PaymentTypeDesc]   CHAR (10)     NOT NULL,
    [PaymentEntityDesc] CHAR (10)     NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    CONSTRAINT [PK_PaymentCodeLookup] PRIMARY KEY CLUSTERED ([PaymentCodeId] ASC) ON [CLAIMSCD]
) ON [CLAIMSCD];

