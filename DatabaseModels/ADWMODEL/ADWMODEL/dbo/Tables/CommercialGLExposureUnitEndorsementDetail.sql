CREATE TABLE [dbo].[CommercialGLExposureUnitEndorsementDetail] (
    [PolicyId]              INT            NOT NULL,
    [EndorsementDetailId]   INT            NOT NULL,
    [EndorsementId]         INT            NOT NULL,
    [UnitNbr]               INT            NOT NULL,
    [SequenceNbr]           CHAR (3)       NOT NULL,
    [EndorsementLimitAmt]   DECIMAL (9)    NULL,
    [EndorsementPremiumAmt] DECIMAL (9, 2) NULL,
    [EndorsementItemDesc]   VARCHAR (255)  NULL,
    [CreatedTmstmp]         DATETIME       NOT NULL,
    [UserCreatedId]         CHAR (8)       NOT NULL,
    [UpdatedTmstmp]         DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]         CHAR (8)       NOT NULL,
    [LastActionCd]          CHAR (1)       NOT NULL,
    [SourceSystemCd]        CHAR (2)       NOT NULL,
    CONSTRAINT [PK_CommercialGLExposureUnitEndorsementDetail] PRIMARY KEY CLUSTERED ([EndorsementDetailId] ASC, [EndorsementId] ASC, [UnitNbr] ASC, [PolicyId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_CommercialGLExposureUnitEndorsementDetail_CommercialGLExposureUnitEndorsement_01] FOREIGN KEY ([UnitNbr], [PolicyId], [EndorsementId]) REFERENCES [dbo].[CommercialGLExposureUnitEndorsement] ([UnitNbr], [PolicyId], [EndorsementId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_CommercialGLExposureUnitEndorsementDetail_01]
    ON [dbo].[CommercialGLExposureUnitEndorsementDetail]([PolicyId] ASC)
    ON [POLICYCI];

